import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shift7_app/core/errors/error_message.dart';
import 'package:shift7_app/core/errors/failures.dart';
import 'package:shift7_app/core/network/api_config.dart';
import 'package:shift7_app/core/network/api_service.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/cache_helper_keys.dart';
import 'package:shift7_app/core/services/notification_service.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/features/auth/data/repos/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final ApiService apiService;
  final GoogleSignIn googleSignIn;
  final NotificationService notificationService;

  AuthRepoImpl({
    required this.apiService,
    required this.googleSignIn,
    NotificationService? notificationService,
  }) : notificationService =
           notificationService ?? NotificationService.instance;

  Future<void> _syncFcmAfterAuth() async {
    try {
      await notificationService.sendCurrentTokenToBackend(force: true);
    } catch (e) {
      // Ignore errors
    }
  }

  Future<void> _maybeSaveApiToken(dynamic response) async {
    try {
      final tokenData =
          response is Map<String, dynamic> ? response['data'] : null;
      final token1 =
          tokenData is Map<String, dynamic> ? tokenData['access_token'] : null;

      final token2 =
          response is Map<String, dynamic> ? response['token'] : null;

      final token = (token1 ?? token2)?.toString();

      if (token != null && token.isNotEmpty) {
        await apiService.saveToken(token);
      }
    } catch (e) {
      // Ignore errors in saving token
    }
  }

  @override
  Future<Either<Failures, dynamic>> changePassword({
    String? phone,
    String? email,
    required String confirmPassword,
    required String password,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'password_confirmation': confirmPassword,
        'password': password,
      };

      if (email != null && email.isNotEmpty) {
        data['email'] = email;
      } else if (phone != null && phone.isNotEmpty) {
        data['phone'] = phone;
      }

      final response = await apiService.postData(
        endpoint: ApiConfig.changePassword,
        data: data,
        hasToken: false,
      );

      await _maybeSaveApiToken(response);
      await _syncFcmAfterAuth();

      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, dynamic>> login({
    String? email,
    String? phone,
    required String password,
  }) async {
    try {
      final Map<String, dynamic> data = {'password': password};

      if (email != null && email.isNotEmpty) {
        data['email'] = email;
      } else if (phone != null && phone.isNotEmpty) {
        data['phone'] = phone;
      }

      final response = await apiService.postData(
        endpoint: ApiConfig.login,
        data: data,
        hasToken: false,
      );

      await _maybeSaveApiToken(response);
      await _syncFcmAfterAuth();

      final dynamic rawData = response['data'];
      if (rawData is Map) {
        final dynamic rawUser = rawData['user'];
        if (rawUser is Map && rawUser['name'] != null) {
          await getIt<CacheHelper>().setData(
            key: CacheHelperKeys.userName,
            value: rawUser['name'].toString(),
          );
        }
      }

      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, dynamic>> register({
    required String name,
    String? email,
    String? phone,
    required String password,
    required String otpType,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'name': name,
        'password': password,
        'otp_type': otpType,
      };

      if (email != null && email.isNotEmpty) {
        data['email'] = email;
      } else if (phone != null && phone.isNotEmpty) {
        data['phone'] = phone;
      }

      final response = await apiService.postData(
        endpoint: ApiConfig.register,
        data: data,
        hasToken: false,
      );

      await _maybeSaveApiToken(response);
      await _syncFcmAfterAuth();
      await getIt<CacheHelper>().setData(
        key: CacheHelperKeys.userName,
        value: response['data']["user"]['name'],
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, dynamic>> sentOtp({
    String? email,
    String? phone,
    required String type,
  }) async {
    try {
      final Map<String, dynamic> data = {'otp_type': type};

      if (email != null && email.isNotEmpty) {
        data['email'] = email;
      } else if (phone != null && phone.isNotEmpty) {
        data['phone'] = phone;
      }

      final response = await apiService.postData(
        endpoint: ApiConfig.sentOtp,
        data: data,
        hasToken: false,
      );

      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, dynamic>> verifyEmail({
    String? email,
    String? phone,
    required String otp,
  }) async {
    try {
      final Map<String, dynamic> data = {'otp': otp};

      if (email != null && email.isNotEmpty) {
        data['email'] = email;
      } else if (phone != null && phone.isNotEmpty) {
        data['phone'] = phone;
      }

      final response = await apiService.postData(
        endpoint: ApiConfig.verifyEmail,
        data: data,
        hasToken: false,
      );

      await _maybeSaveApiToken(response);
      await _syncFcmAfterAuth();

      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  String serverClientId =
      '767244550542-spa29p9ajgj1cqig7b4esjcurd9mug9l.apps.googleusercontent.com';

  @override
  Future<Either<Failures, dynamic>> googleAuth() async {
    try {
      final GoogleSignIn signIn = GoogleSignIn.instance;
      await signIn.initialize(serverClientId: serverClientId);

      final GoogleSignInAccount googleUser = await signIn.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      if (googleAuth.idToken == null) {
        return Left(
          ServerFailure(errorMessage: 'Google authentication failed.'),
        );
      }

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      final String? firebaseToken = await userCredential.user?.getIdToken();
      if (firebaseToken == null) {
        return Left(
          ServerFailure(errorMessage: 'Failed to get Firebase token.'),
        );
      }

      final response = await apiService.postData(
        endpoint: ApiConfig.googleAuth,
        data: {'token': firebaseToken},
        hasToken: false,
      );

      await _maybeSaveApiToken(response);
      await _syncFcmAfterAuth();
      await getIt<CacheHelper>().setData(
        key: CacheHelperKeys.userName,
        value: response["user"]['name'],
      );

      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    } catch (e) {
      return Left(ServerFailure(errorMessage: 'An unknown error occurred.'));
    }
  }

  @override
  Future<Either<Failures, dynamic>> verifyCodeOfForgetPassword({
    String? email,
    String? phone,
    required String otp,
  }) async {
    try {
      final Map<String, dynamic> data = {'otp': otp};

      if (email != null && email.isNotEmpty) {
        data['email'] = email;
      } else if (phone != null && phone.isNotEmpty) {
        data['phone'] = phone;
      }

      final response = await apiService.postData(
        endpoint: ApiConfig.verifyCodeOfForgetPassword,
        data: data,
        hasToken: false,
      );

      await _maybeSaveApiToken(response);
      await _syncFcmAfterAuth();

      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }
}
