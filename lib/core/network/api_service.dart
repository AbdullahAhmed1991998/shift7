import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shift7_app/core/errors/failures.dart';
import 'package:shift7_app/core/network/api_config.dart';
import 'package:shift7_app/core/network/api_keys.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/service_locator.dart';

class ApiService {
  static const String _baseUrl = ApiConfig.baseUrl;
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  ApiService({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
      _dio = Dio(
        BaseOptions(
          baseUrl: _baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      ) {
    _dio.interceptors.addAll([
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    ]);
  }

  String get _languageCode {
    final isArabic = getIt<CacheHelper>().getData(key: 'language') == 'ar';
    return isArabic ? 'ar' : 'en';
  }

  getToken() async {
    return await _secureStorage.read(key: userToken);
  }

  Options _buildOptions({
    required bool hasToken,
    Map<String, dynamic>? headers,
  }) {
    return Options(
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Accept-Language': _languageCode,
        ...?headers,
      },
    );
  }

  Future<T> getData<T>({
    required String endpoint,
    required Map<String, dynamic> query,
    required T Function(dynamic) fromJson,
    Map<String, dynamic>? data,
    required bool hasToken,
  }) async {
    final options = _buildOptions(
      hasToken: hasToken,
      headers:
          hasToken ? {'Authorization': 'Bearer ${await getToken()}'} : null,
    );

    final response = await _dio.get(
      endpoint,
      queryParameters: query,
      data: data,
      options: options,
    );

    return fromJson(response.data);
  }

  Future<T> postData<T>({
    required String endpoint,
    Map<String, dynamic>? data,
    FormData? formData,
    bool hasFormData = false,
    bool hasToken = false,
    T Function(dynamic)? fromJson,
  }) async {
    final options = _buildOptions(
      hasToken: hasToken,
      headers:
          hasToken ? {'Authorization': 'Bearer ${await getToken()}'} : null,
    );

    final response = await _dio.post(
      endpoint,
      data: hasFormData ? formData : data,
      options: options,
    );

    return fromJson != null ? fromJson(response.data) : response.data as T;
  }

  Future<T> putData<T>({
    required String endpoint,
    Map<String, dynamic>? data,
    FormData? formData,
    bool hasFormData = false,
    bool hasToken = false,
    T Function(dynamic)? fromJson,
  }) async {
    final options = _buildOptions(
      hasToken: hasToken,
      headers:
          hasToken ? {'Authorization': 'Bearer ${await getToken()}'} : null,
    );

    final response = await _dio.put(
      endpoint,
      data: hasFormData ? formData : data,
      options: options,
    );

    return fromJson != null ? fromJson(response.data) : response.data as T;
  }

  Future<T> deleteData<T>({
    required String endpoint,
    Map<String, dynamic>? data,
    bool hasToken = false,
    T Function(dynamic)? fromJson,
  }) async {
    final options = _buildOptions(
      hasToken: hasToken,
      headers:
          hasToken ? {'Authorization': 'Bearer ${await getToken()}'} : null,
    );

    final response = await _dio.delete(endpoint, data: data, options: options);

    return fromJson != null ? fromJson(response.data) : response.data as T;
  }

  Future<void> saveToken(String token) async {
    try {
      await _secureStorage.write(key: userToken, value: token);
    } catch (e) {
      throw ServerFailure(errorMessage: 'Failed to save token');
    }
  }

  Future<void> clearToken() async {
    try {
      await _secureStorage.delete(key: userToken);
    } catch (e) {
      throw ServerFailure(errorMessage: 'Failed to clear token');
    }
  }
}
