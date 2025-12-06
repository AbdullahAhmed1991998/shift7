import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:shift7_app/core/network/api_service.dart';
import 'package:shift7_app/core/services/firebase_options.dart';

Future<void> registerMessagingBackgroundHandler() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    DartPluginRegistrant.ensureInitialized();
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    if (NotificationService._shouldShowLocal(message, isForeground: false)) {
      await NotificationService.instance._initLocalIfNeeded();
      await NotificationService.instance.showNotification(message);
    }
  } catch (e) {
    debugPrint('BG handler error: $e');
  }
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  FirebaseMessaging get _messaging => FirebaseMessaging.instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final ApiService _apiService = ApiService();

  static const String _fcmTokenKey = 'fcm_token';
  static const String _androidSmallIconName = 'ic_stat_notify';

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
    showBadge: true,
  );

  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  bool _localInitialized = false;
  bool _fullyInitialized = false;

  static bool _shouldShowLocal(RemoteMessage m, {required bool isForeground}) {
    final hasNotif = m.notification != null;
    if (Platform.isAndroid) {
      if (isForeground) return true;
      return !hasNotif;
    } else {
      return !hasNotif;
    }
  }

  Future<void> _ensureFirebaseInitialized() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  }

  Future<void> initialize() async {
    if (_fullyInitialized) return;
    try {
      await _ensureFirebaseInitialized();

      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      await _requestPermission();
      await _initLocalIfNeeded();
      await _createAndroidChannelIfNeeded();
      await _setupMessageHandlers();
      await _bootstrapToken();

      _fullyInitialized = true;
      debugPrint('NotificationService initialized.');
    } catch (e) {
      debugPrint('NotificationService initialize error: $e');
    }
  }

  Future<void> _bootstrapToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        await _handleFcmToken(token);
      }
      _messaging.onTokenRefresh.listen(_handleFcmToken);
    } catch (e) {
      debugPrint('Initial token retrieval error: $e');
    }
  }

  Future<void> _handleFcmToken(String token) async {
    try {
      final storedToken = await _secureStorage.read(key: _fcmTokenKey);
      if (storedToken == token) {
        debugPrint('FCM token unchanged, skipping backend update');
        return;
      }
      await _secureStorage.write(key: _fcmTokenKey, value: token);
      debugPrint('Stored FCM Token: $token');
      await _sendTokenToBackend(token);
    } catch (e) {
      debugPrint('FCM token handling error: $e');
    }
  }

  Future<void> sendCurrentTokenToBackend({bool force = false}) async {
    try {
      await _ensureFirebaseInitialized();
      final token = await _messaging.getToken();
      if (token == null) return;
      if (force) {
        await _secureStorage.write(key: _fcmTokenKey, value: token);
        await _sendTokenToBackend(token);
      } else {
        await _handleFcmToken(token);
      }
    } catch (e) {
      debugPrint('sendCurrentTokenToBackend error: $e');
    }
  }

  Future<void> _sendTokenToBackend(String token) async {
    try {
      await _apiService.putData<dynamic>(
        endpoint: '/notification/update-fcm',
        hasToken: true,
        data: {'fcm_token': token},
      );
      debugPrint('FCM token sent to backend successfully');
    } catch (e) {
      debugPrint('FCM token sending error: $e');
    }
  }

  Future<void> _requestPermission() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
      debugPrint('Notification permission: ${settings.authorizationStatus}');

      await _local
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);

      await _local
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    } catch (e) {
      debugPrint('Permission request error: $e');
    }
  }

  Future<void> _initLocalIfNeeded() async {
    if (_localInitialized) return;
    try {
      const androidInit = AndroidInitializationSettings(_androidSmallIconName);
      const iosInit = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      const initSettings = InitializationSettings(
        android: androidInit,
        iOS: iosInit,
      );
      await _local.initialize(
        initSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse resp) async =>
                _handleNotificationAction(resp.payload ?? '{}'),
      );
      _localInitialized = true;
    } catch (e) {
      debugPrint('Local notifications init error: $e');
    }
  }

  Future<void> _createAndroidChannelIfNeeded() async {
    try {
      await _local
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(_channel);
    } catch (e) {
      debugPrint('Create channel error: $e');
    }
  }

  Future<void> showNotification(RemoteMessage message) async {
    try {
      if (kIsWeb) return;
      final n = message.notification;
      final data = message.data;
      if (n == null && data.isEmpty) return;

      final String? title = n?.title ?? data['title']?.toString();
      final String? body = n?.body ?? data['body']?.toString();

      final androidDetails = AndroidNotificationDetails(
        _channel.id,
        _channel.name,
        channelDescription: _channel.description,
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        icon: _androidSmallIconName,
        largeIcon: DrawableResourceAndroidBitmap(_androidSmallIconName),
      );
      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      final details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      final int id = n?.hashCode ?? DateTime.now().millisecondsSinceEpoch;
      final payload = jsonEncode({
        'route': data['route'],
        'type': data['type'],
        'id': data['id'],
        'raw': data,
      });

      await _local.show(id, title, body, details, payload: payload);
    } catch (e) {
      debugPrint('Show notification error: $e');
    }
  }

  Future<void> _setupMessageHandlers() async {
    try {
      FirebaseMessaging.onMessage.listen((m) {
        if (_shouldShowLocal(m, isForeground: true)) {
          showNotification(m);
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      final initial = await _messaging.getInitialMessage();
      if (initial != null) {
        _handleNotificationTap(initial);
      }
    } catch (e) {
      debugPrint('Message handlers setup error: $e');
    }
  }

  void _handleNotificationTap(RemoteMessage message) {
    try {
      final data = message.data;
      debugPrint('Opened from notification: $data');
    } catch (e) {
      debugPrint('Tap handler error: $e');
    }
  }

  Future<void> _handleNotificationAction(String payload) async {
    try {
      final map = jsonDecode(payload) as Map<String, dynamic>;
      debugPrint('Tapped action payload: $map');
    } catch (_) {}
  }
}
