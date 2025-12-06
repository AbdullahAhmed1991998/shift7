import 'package:dartz/dartz.dart';
import 'package:shift7_app/core/errors/failures.dart';
import 'package:shift7_app/features/profile/data/models/get_help_center_model.dart';
import 'package:shift7_app/features/profile/data/models/get_my_orders_model.dart';
import 'package:shift7_app/features/profile/data/models/get_notifications_model.dart';
import 'package:shift7_app/features/profile/data/models/get_social_media_model.dart';
import 'package:shift7_app/features/profile/data/models/get_user_address_model.dart';
import 'package:shift7_app/features/profile/data/models/privacy_and_policy_model.dart';
import 'package:shift7_app/features/profile/data/models/user_profile_data_model.dart';

abstract class ProfileRepo {
  Future<Either<Failures, dynamic>> updateProfile({
    required String name,
    required String email,
    required String pass,
    required String phone,
  });
  Future<Either<Failures, UserProfileDataModel>> getProfile();
  Future<Either<Failures, dynamic>> setLocation({
    required String addressLine1,
    required String addressLine2,
    required String city,
    required String country,
    required String governorate,
    required String zipCode,
    required String long,
    required String lat,
  });
  Future<Either<Failures, dynamic>> deleteLocation({required int addressId});
  Future<Either<Failures, GetUserAddressModel>> getUserLocations();
  Future<Either<Failures, GetNotificationsModel>> getAllNotifications({
    required int page,
    required int limit,
  });
  Future<Either<Failures, PrivacyAndPolicyModel>> getPrivacyAndPolicy();
  Future<Either<Failures, GetHelpCenterModel>> getHelpCenter();
  Future<Either<Failures, GetSocialMediaModel>> getSocialMedia();
  Future<Either<Failures, dynamic>> seenNotifications({
    required int notificationId,
  });
  Future<Either<Failures, dynamic>> logOut();
  Future<Either<Failures, GetMyOrdersModel>> getMyOrders({
    required int page,
    required int limit,
  });
  Future<Either<Failures, dynamic>> deleteAccount();
}
