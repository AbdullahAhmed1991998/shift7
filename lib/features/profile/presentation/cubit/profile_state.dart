part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  final ApiStatus status;
  final UserProfileDataModel? profile;
  final String errorMessage;

  final ApiStatus addressesStatus;
  final GetUserAddressModel? addresses;
  final String addressesErrorMessage;

  final ApiStatus socialStatus;
  final GetSocialMediaModel? socialData;
  final String socialErrorMessage;

  final ApiStatus helpStatus;
  final GetHelpCenterModel? helpData;
  final String helpErrorMessage;

  final ApiStatus setLocationStatus;
  final String setLocationErrorMessage;

  final ApiStatus deleteLocationStatus;
  final String deleteLocationErrorMessage;

  final ApiStatus updateProfileStatus;
  final String updateProfileErrorMessage;

  final ApiStatus privacyStatus;
  final PrivacyAndPolicyModel? privacyData;
  final String privacyErrorMessage;

  final ApiStatus notificationsStatus;
  final GetNotificationsModel? notificationsData;
  final String notificationsErrorMessage;

  final ApiStatus logOutStatus;
  final ApiStatus deleteAccountStatus;
  final String deleteAccountErrorMessage;
  final ApiStatus seenNotificationsStatus;

  final List<NotificationItem> notificationItems;
  final bool notificationsLoadingMore;
  final bool notificationsHasMore;
  final int notificationsCurrentPage;

  final ApiStatus ordersStatus;
  final GetMyOrdersModel? ordersData;
  final String ordersErrorMessage;
  final List<OrderModel> orderItems;
  final bool ordersLoadingMore;
  final bool ordersHasMore;
  final int ordersCurrentPage;

  const ProfileState({
    this.status = ApiStatus.initial,
    this.profile,
    this.errorMessage = '',
    this.addressesStatus = ApiStatus.initial,
    this.addresses,
    this.addressesErrorMessage = '',
    this.socialStatus = ApiStatus.initial,
    this.socialData,
    this.socialErrorMessage = '',
    this.helpStatus = ApiStatus.initial,
    this.helpData,
    this.helpErrorMessage = '',
    this.setLocationStatus = ApiStatus.initial,
    this.setLocationErrorMessage = '',
    this.deleteLocationStatus = ApiStatus.initial,
    this.deleteLocationErrorMessage = '',
    this.updateProfileStatus = ApiStatus.initial,
    this.updateProfileErrorMessage = '',
    this.privacyStatus = ApiStatus.initial,
    this.privacyData,
    this.privacyErrorMessage = '',
    this.notificationsStatus = ApiStatus.initial,
    this.notificationsData,
    this.notificationsErrorMessage = '',
    this.logOutStatus = ApiStatus.initial,
    this.deleteAccountStatus = ApiStatus.initial,
    this.deleteAccountErrorMessage = '',
    this.seenNotificationsStatus = ApiStatus.initial,
    this.notificationItems = const [],
    this.notificationsLoadingMore = false,
    this.notificationsHasMore = true,
    this.notificationsCurrentPage = 0,
    this.ordersStatus = ApiStatus.initial,
    this.ordersData,
    this.ordersErrorMessage = '',
    this.orderItems = const [],
    this.ordersLoadingMore = false,
    this.ordersHasMore = true,
    this.ordersCurrentPage = 0,
  });

  factory ProfileState.initial() => const ProfileState();

  ProfileState copyWith({
    ApiStatus? status,
    UserProfileDataModel? profile,
    String? errorMessage,
    ApiStatus? addressesStatus,
    GetUserAddressModel? addresses,
    String? addressesErrorMessage,
    ApiStatus? socialStatus,
    GetSocialMediaModel? socialData,
    String? socialErrorMessage,
    ApiStatus? helpStatus,
    GetHelpCenterModel? helpData,
    String? helpErrorMessage,
    ApiStatus? setLocationStatus,
    String? setLocationErrorMessage,
    ApiStatus? deleteLocationStatus,
    String? deleteLocationErrorMessage,
    ApiStatus? updateProfileStatus,
    String? updateProfileErrorMessage,
    ApiStatus? privacyStatus,
    PrivacyAndPolicyModel? privacyData,
    String? privacyErrorMessage,
    ApiStatus? notificationsStatus,
    GetNotificationsModel? notificationsData,
    String? notificationsErrorMessage,
    ApiStatus? logOutStatus,
    ApiStatus? deleteAccountStatus,
    String? deleteAccountErrorMessage,
    ApiStatus? seenNotificationsStatus,
    List<NotificationItem>? notificationItems,
    bool? notificationsLoadingMore,
    bool? notificationsHasMore,
    int? notificationsCurrentPage,
    ApiStatus? ordersStatus,
    GetMyOrdersModel? ordersData,
    String? ordersErrorMessage,
    List<OrderModel>? orderItems,
    bool? ordersLoadingMore,
    bool? ordersHasMore,
    int? ordersCurrentPage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
      addressesStatus: addressesStatus ?? this.addressesStatus,
      addresses: addresses ?? this.addresses,
      addressesErrorMessage:
          addressesErrorMessage ?? this.addressesErrorMessage,
      socialStatus: socialStatus ?? this.socialStatus,
      socialData: socialData ?? this.socialData,
      socialErrorMessage: socialErrorMessage ?? this.socialErrorMessage,
      helpStatus: helpStatus ?? this.helpStatus,
      helpData: helpData ?? this.helpData,
      helpErrorMessage: helpErrorMessage ?? this.helpErrorMessage,
      setLocationStatus: setLocationStatus ?? this.setLocationStatus,
      setLocationErrorMessage:
          setLocationErrorMessage ?? this.setLocationErrorMessage,
      deleteLocationStatus: deleteLocationStatus ?? this.deleteLocationStatus,
      deleteLocationErrorMessage:
          deleteLocationErrorMessage ?? this.deleteLocationErrorMessage,
      updateProfileStatus: updateProfileStatus ?? this.updateProfileStatus,
      updateProfileErrorMessage:
          updateProfileErrorMessage ?? this.updateProfileErrorMessage,
      privacyStatus: privacyStatus ?? this.privacyStatus,
      privacyData: privacyData ?? this.privacyData,
      privacyErrorMessage: privacyErrorMessage ?? this.privacyErrorMessage,
      notificationsStatus: notificationsStatus ?? this.notificationsStatus,
      notificationsData: notificationsData ?? this.notificationsData,
      notificationsErrorMessage:
          notificationsErrorMessage ?? this.notificationsErrorMessage,
      logOutStatus: logOutStatus ?? this.logOutStatus,
      deleteAccountStatus: deleteAccountStatus ?? this.deleteAccountStatus,
      deleteAccountErrorMessage:
          deleteAccountErrorMessage ?? this.deleteAccountErrorMessage,
      seenNotificationsStatus:
          seenNotificationsStatus ?? this.seenNotificationsStatus,
      notificationItems: notificationItems ?? this.notificationItems,
      notificationsLoadingMore:
          notificationsLoadingMore ?? this.notificationsLoadingMore,
      notificationsHasMore: notificationsHasMore ?? this.notificationsHasMore,
      notificationsCurrentPage:
          notificationsCurrentPage ?? this.notificationsCurrentPage,
      ordersStatus: ordersStatus ?? this.ordersStatus,
      ordersData: ordersData ?? this.ordersData,
      ordersErrorMessage: ordersErrorMessage ?? this.ordersErrorMessage,
      orderItems: orderItems ?? this.orderItems,
      ordersLoadingMore: ordersLoadingMore ?? this.ordersLoadingMore,
      ordersHasMore: ordersHasMore ?? this.ordersHasMore,
      ordersCurrentPage: ordersCurrentPage ?? this.ordersCurrentPage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    profile,
    errorMessage,
    addressesStatus,
    addresses,
    addressesErrorMessage,
    socialStatus,
    socialData,
    socialErrorMessage,
    helpStatus,
    helpData,
    helpErrorMessage,
    setLocationStatus,
    setLocationErrorMessage,
    deleteLocationStatus,
    deleteLocationErrorMessage,
    updateProfileStatus,
    updateProfileErrorMessage,
    privacyStatus,
    privacyData,
    privacyErrorMessage,
    notificationsStatus,
    notificationsData,
    notificationsErrorMessage,
    logOutStatus,
    deleteAccountStatus,
    deleteAccountErrorMessage,
    seenNotificationsStatus,
    notificationItems,
    notificationsLoadingMore,
    notificationsHasMore,
    notificationsCurrentPage,
    ordersStatus,
    ordersData,
    ordersErrorMessage,
    orderItems,
    ordersLoadingMore,
    ordersHasMore,
    ordersCurrentPage,
  ];
}
