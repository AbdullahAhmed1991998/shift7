import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shift7_app/core/errors/failures.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/features/profile/data/models/get_my_orders_model.dart';
import 'package:shift7_app/features/profile/data/models/get_notifications_model.dart';
import 'package:shift7_app/features/profile/data/models/get_help_center_model.dart';
import 'package:shift7_app/features/profile/data/models/get_social_media_model.dart';
import 'package:shift7_app/features/profile/data/models/get_user_address_model.dart';
import 'package:shift7_app/features/profile/data/models/privacy_and_policy_model.dart';
import 'package:shift7_app/features/profile/data/models/user_profile_data_model.dart';
import 'package:shift7_app/features/profile/data/repos/profile_repo.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo repository;

  ProfileCubit({required this.repository}) : super(ProfileState.initial());

  void _safeEmit(ProfileState newState) {
    if (!isClosed) emit(newState);
  }

  Future<void> getProfile() async {
    _safeEmit(state.copyWith(status: ApiStatus.loading, errorMessage: ''));
    final result = await repository.getProfile();
    result.fold(
      (failure) {
        _safeEmit(
          state.copyWith(
            status: ApiStatus.error,
            errorMessage: _mapFailure(failure),
          ),
        );
      },
      (profile) {
        _safeEmit(state.copyWith(status: ApiStatus.success, profile: profile));
      },
    );
  }

  Future<void> getUserLocations() async {
    _safeEmit(
      state.copyWith(
        addressesStatus: ApiStatus.loading,
        addressesErrorMessage: '',
      ),
    );
    final result = await repository.getUserLocations();
    result.fold(
      (failure) {
        _safeEmit(
          state.copyWith(
            addressesStatus: ApiStatus.error,
            addressesErrorMessage: _mapFailure(failure),
          ),
        );
      },
      (addresses) {
        _safeEmit(
          state.copyWith(
            addressesStatus: ApiStatus.success,
            addresses: addresses,
          ),
        );
      },
    );
  }

  Future<void> setLocation({
    required String addressLine1,
    required String addressLine2,
    required String city,
    required String country,
    required String governorate,
    required String zipCode,
    required String long,
    required String lat,
  }) async {
    _safeEmit(
      state.copyWith(
        setLocationStatus: ApiStatus.loading,
        setLocationErrorMessage: '',
      ),
    );
    final result = await repository.setLocation(
      addressLine1: addressLine1,
      addressLine2: addressLine2,
      city: city,
      country: country,
      governorate: governorate,
      zipCode: zipCode,
      long: long,
      lat: lat,
    );
    result.fold(
      (failure) {
        _safeEmit(
          state.copyWith(
            setLocationStatus: ApiStatus.error,
            setLocationErrorMessage: _mapFailure(failure),
          ),
        );
      },
      (_) {
        _safeEmit(state.copyWith(setLocationStatus: ApiStatus.success));
      },
    );
  }

  Future<void> deleteLocation({required int addressId}) async {
    _safeEmit(
      state.copyWith(
        deleteLocationStatus: ApiStatus.loading,
        deleteLocationErrorMessage: '',
      ),
    );
    final result = await repository.deleteLocation(addressId: addressId);
    result.fold(
      (failure) {
        _safeEmit(
          state.copyWith(
            deleteLocationStatus: ApiStatus.error,
            deleteLocationErrorMessage: _mapFailure(failure),
          ),
        );
      },
      (_) {
        _safeEmit(state.copyWith(deleteLocationStatus: ApiStatus.success));
      },
    );
  }

  Future<void> getSocialMedia() async {
    _safeEmit(
      state.copyWith(socialStatus: ApiStatus.loading, socialErrorMessage: ''),
    );
    final result = await repository.getSocialMedia();
    result.fold(
      (failure) {
        _safeEmit(
          state.copyWith(
            socialStatus: ApiStatus.error,
            socialErrorMessage: _mapFailure(failure),
          ),
        );
      },
      (social) {
        _safeEmit(
          state.copyWith(socialStatus: ApiStatus.success, socialData: social),
        );
      },
    );
  }

  Future<void> getHelpCenter() async {
    _safeEmit(
      state.copyWith(helpStatus: ApiStatus.loading, helpErrorMessage: ''),
    );
    final result = await repository.getHelpCenter();
    result.fold(
      (failure) {
        _safeEmit(
          state.copyWith(
            helpStatus: ApiStatus.error,
            helpErrorMessage: _mapFailure(failure),
          ),
        );
      },
      (help) {
        _safeEmit(
          state.copyWith(helpStatus: ApiStatus.success, helpData: help),
        );
      },
    );
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String pass,
    required String phone,
  }) async {
    _safeEmit(
      state.copyWith(
        updateProfileStatus: ApiStatus.loading,
        updateProfileErrorMessage: '',
      ),
    );
    final result = await repository.updateProfile(
      name: name,
      email: email,
      pass: pass,
      phone: phone,
    );
    result.fold(
      (failure) {
        _safeEmit(
          state.copyWith(
            updateProfileStatus: ApiStatus.error,
            updateProfileErrorMessage: _mapFailure(failure),
          ),
        );
      },
      (_) {
        _safeEmit(state.copyWith(updateProfileStatus: ApiStatus.success));
      },
    );
  }

  Future<void> getPrivacyAndPolicy() async {
    _safeEmit(
      state.copyWith(privacyStatus: ApiStatus.loading, privacyErrorMessage: ''),
    );
    final result = await repository.getPrivacyAndPolicy();
    result.fold(
      (failure) {
        _safeEmit(
          state.copyWith(
            privacyStatus: ApiStatus.error,
            privacyErrorMessage: _mapFailure(failure),
          ),
        );
      },
      (privacy) {
        _safeEmit(
          state.copyWith(
            privacyStatus: ApiStatus.success,
            privacyData: privacy,
          ),
        );
      },
    );
  }

  static const int _initialLimit = 10;

  Future<void> initAllNotifications() async {
    _safeEmit(
      state.copyWith(
        notificationsStatus: ApiStatus.loading,
        notificationsErrorMessage: '',
        notificationItems: const [],
        notificationsCurrentPage: 1,
        notificationsHasMore: true,
        notificationsLoadingMore: false,
      ),
    );

    final result = await repository.getAllNotifications(
      page: 1,
      limit: _initialLimit,
    );

    result.fold(
      (failure) {
        _safeEmit(
          state.copyWith(
            notificationsStatus: ApiStatus.error,
            notificationsErrorMessage: _mapFailure(failure),
          ),
        );
      },
      (notifications) {
        final items = notifications.data.items;
        _safeEmit(
          state.copyWith(
            notificationsStatus: ApiStatus.success,
            notificationsData: notifications,
            notificationItems: items,
            notificationsHasMore: items.length >= _initialLimit,
            notificationsCurrentPage: 1,
          ),
        );
      },
    );
  }

  Future<void> loadMoreNotifications() async {
    if (state.notificationsStatus != ApiStatus.success) return;
    if (!state.notificationsHasMore) return;
    if (state.notificationsLoadingMore) return;

    final nextPage = state.notificationsCurrentPage + 1;
    _safeEmit(state.copyWith(notificationsLoadingMore: true));

    final result = await repository.getAllNotifications(
      page: nextPage,
      limit: _initialLimit,
    );

    result.fold(
      (failure) {
        _safeEmit(
          state.copyWith(
            notificationsLoadingMore: false,
            notificationsErrorMessage: _mapFailure(failure),
          ),
        );
      },
      (notifications) {
        final newItems = notifications.data.items;

        if (newItems.isEmpty) {
          _safeEmit(
            state.copyWith(
              notificationsLoadingMore: false,
              notificationsHasMore: false,
            ),
          );
          return;
        }

        final merged = [...state.notificationItems, ...newItems];

        _safeEmit(
          state.copyWith(
            notificationsData: notifications,
            notificationItems: merged,
            notificationsLoadingMore: false,
            notificationsCurrentPage: nextPage,
            notificationsHasMore: newItems.length >= _initialLimit,
          ),
        );
      },
    );
  }

  Future<void> getAllNotifications() async {
    _safeEmit(
      state.copyWith(
        notificationsStatus: ApiStatus.loading,
        notificationsErrorMessage: '',
      ),
    );
    final result = await repository.getAllNotifications(
      page: 1,
      limit: _initialLimit,
    );
    result.fold(
      (failure) {
        _safeEmit(
          state.copyWith(
            notificationsStatus: ApiStatus.error,
            notificationsErrorMessage: _mapFailure(failure),
          ),
        );
      },
      (notifications) {
        _safeEmit(
          state.copyWith(
            notificationsStatus: ApiStatus.success,
            notificationsData: notifications,
            notificationItems: notifications.data.items,
          ),
        );
      },
    );
  }

  Future<void> initMyOrders() async {
    _safeEmit(
      state.copyWith(
        ordersStatus: ApiStatus.loading,
        ordersErrorMessage: '',
        orderItems: const [],
        ordersCurrentPage: 1,
        ordersHasMore: true,
        ordersLoadingMore: false,
      ),
    );

    final result = await repository.getMyOrders(page: 1, limit: _initialLimit);

    result.fold(
      (failure) {
        _safeEmit(
          state.copyWith(
            ordersStatus: ApiStatus.error,
            ordersErrorMessage: _mapFailure(failure),
          ),
        );
      },
      (orders) {
        final items = orders.data?.orders ?? [];
        _safeEmit(
          state.copyWith(
            ordersStatus: ApiStatus.success,
            ordersData: orders,
            orderItems: items,
            ordersHasMore:
                items.length >= _initialLimit &&
                (orders.data?.total ?? 0) > items.length,
            ordersCurrentPage: 1,
          ),
        );
      },
    );
  }

  Future<void> loadMoreMyOrders() async {
    if (state.ordersStatus != ApiStatus.success) return;
    if (!state.ordersHasMore) return;
    if (state.ordersLoadingMore) return;

    final nextPage = state.ordersCurrentPage + 1;
    _safeEmit(state.copyWith(ordersLoadingMore: true));

    final result = await repository.getMyOrders(
      page: nextPage,
      limit: _initialLimit,
    );

    result.fold(
      (failure) {
        _safeEmit(
          state.copyWith(
            ordersLoadingMore: false,
            ordersErrorMessage: _mapFailure(failure),
          ),
        );
      },
      (orders) {
        final newItems = orders.data?.orders ?? [];

        if (newItems.isEmpty) {
          _safeEmit(
            state.copyWith(ordersLoadingMore: false, ordersHasMore: false),
          );
          return;
        }

        final merged = [...state.orderItems, ...newItems];

        _safeEmit(
          state.copyWith(
            ordersData: orders,
            orderItems: merged,
            ordersLoadingMore: false,
            ordersCurrentPage: nextPage,
            ordersHasMore:
                newItems.length >= _initialLimit &&
                merged.length < (orders.data?.total ?? merged.length),
          ),
        );
      },
    );
  }

  Future<void> logOut() async {
    _safeEmit(state.copyWith(logOutStatus: ApiStatus.loading));
    final result = await repository.logOut();
    result.fold(
      (failure) {
        _safeEmit(state.copyWith(logOutStatus: ApiStatus.error));
      },
      (_) {
        _safeEmit(state.copyWith(logOutStatus: ApiStatus.success));
      },
    );
  }

  Future<void> deleteAccount() async {
    _safeEmit(
      state.copyWith(
        deleteAccountStatus: ApiStatus.loading,
        deleteAccountErrorMessage: '',
      ),
    );

    final result = await repository.deleteAccount();

    result.fold(
      (failure) {
        _safeEmit(
          state.copyWith(
            deleteAccountStatus: ApiStatus.error,
            deleteAccountErrorMessage: _mapFailure(failure),
          ),
        );
      },
      (_) {
        _safeEmit(state.copyWith(deleteAccountStatus: ApiStatus.success));
      },
    );
  }

  Future<void> seenNotifications({required int notificationId}) async {
    _safeEmit(state.copyWith(seenNotificationsStatus: ApiStatus.loading));
    final result = await repository.seenNotifications(
      notificationId: notificationId,
    );
    result.fold(
      (failure) {
        _safeEmit(state.copyWith(seenNotificationsStatus: ApiStatus.error));
      },
      (_) {
        _safeEmit(state.copyWith(seenNotificationsStatus: ApiStatus.success));
      },
    );
  }

  String _mapFailure(Failures failure) {
    if (failure is ServerFailure) return failure.errorMessage;
    return failure.toString();
  }
}
