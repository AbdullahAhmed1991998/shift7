import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shift7_app/core/errors/error_message.dart';
import 'package:shift7_app/core/errors/failures.dart';
import 'package:shift7_app/core/network/api_config.dart';
import 'package:shift7_app/core/network/api_service.dart';
import 'package:shift7_app/features/profile/data/models/get_help_center_model.dart';
import 'package:shift7_app/features/profile/data/models/get_my_orders_model.dart';
import 'package:shift7_app/features/profile/data/models/get_notifications_model.dart';
import 'package:shift7_app/features/profile/data/models/get_social_media_model.dart';
import 'package:shift7_app/features/profile/data/models/get_user_address_model.dart';
import 'package:shift7_app/features/profile/data/models/privacy_and_policy_model.dart';
import 'package:shift7_app/features/profile/data/models/user_profile_data_model.dart';
import 'package:shift7_app/features/profile/data/repos/profile_repo.dart';

class ProfileRepoImpl implements ProfileRepo {
  final ApiService apiService;
  ProfileRepoImpl({required this.apiService});
  @override
  Future<Either<Failures, dynamic>> deleteLocation({
    required int addressId,
  }) async {
    try {
      final response = await apiService.deleteData(
        endpoint: '${ApiConfig.deleteLocation}/$addressId',
        hasToken: true,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, GetNotificationsModel>> getAllNotifications({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await apiService.getData(
        endpoint: ApiConfig.getNotifications,
        hasToken: true,
        query: {"page": page, "limit": limit},
        fromJson: (json) => GetNotificationsModel.fromJson(json),
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, GetHelpCenterModel>> getHelpCenter() async {
    try {
      final response = await apiService.getData(
        endpoint: ApiConfig.getHelpCenter,
        hasToken: true,
        query: {},
        fromJson: (json) => GetHelpCenterModel.fromJson(json),
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, GetUserAddressModel>> getUserLocations() async {
    try {
      final response = await apiService.getData(
        endpoint: ApiConfig.getUserLocations,
        hasToken: true,
        query: {},
        fromJson: (json) => GetUserAddressModel.fromJson(json),
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, PrivacyAndPolicyModel>> getPrivacyAndPolicy() async {
    try {
      final response = await apiService.getData(
        endpoint: ApiConfig.getPrivacyAndPolicy,
        hasToken: true,
        query: {},
        fromJson: (json) => PrivacyAndPolicyModel.fromJson(json),
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, UserProfileDataModel>> getProfile() async {
    try {
      final response = await apiService.getData(
        endpoint: ApiConfig.getProfile,
        hasToken: true,
        query: {},
        fromJson: (json) => UserProfileDataModel.fromJson(json),
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, GetSocialMediaModel>> getSocialMedia() async {
    try {
      final response = await apiService.getData(
        endpoint: ApiConfig.getSocialMedia,
        hasToken: false,
        query: {},
        fromJson: (json) => GetSocialMediaModel.fromJson(json),
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, dynamic>> setLocation({
    required String addressLine1,
    required String addressLine2,
    required String city,
    required String country,
    required String governorate,
    required String zipCode,
    required String long,
    required String lat,
  }) async {
    try {
      final response = await apiService.postData(
        endpoint: ApiConfig.setLocation,
        hasToken: true,
        data: {
          "address_line_1": addressLine1,
          "address_line_2": addressLine2,
          "city": city,
          "country": country,
          "governorate": governorate,
          "zip_code": zipCode,
          "long": long,
          "lat": lat,
        },
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, dynamic>> updateProfile({
    required String name,
    required String email,
    required String pass,
    required String phone,
  }) async {
    try {
      final response = await apiService.postData(
        endpoint: ApiConfig.updateProfile,
        hasToken: true,
        data: {"name": name, "email": email, "password": pass, "phone": phone},
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, dynamic>> logOut() async {
    try {
      final response = await apiService.getData(
        endpoint: ApiConfig.logOut,
        hasToken: true,
        query: {},
        fromJson: (json) => json,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, dynamic>> seenNotifications({
    required int notificationId,
  }) async {
    try {
      final response = await apiService.postData(
        endpoint: "${ApiConfig.seenNotifications}/$notificationId/mark-as-read",
        hasToken: true,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, GetMyOrdersModel>> getMyOrders({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await apiService.getData(
        endpoint: ApiConfig.getMyOrders,
        hasToken: true,
        query: {"page": page, "limit": limit},
        fromJson: (json) => GetMyOrdersModel.fromJson(json),
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, dynamic>> deleteAccount() async {
    try {
      final response = await apiService.deleteData(
        endpoint: ApiConfig.deleteAccount,
        hasToken: true,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }
}
