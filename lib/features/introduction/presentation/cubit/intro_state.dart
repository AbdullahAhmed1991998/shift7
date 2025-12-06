part of 'intro_cubit.dart';

class IntroState extends Equatable {
  final ApiStatus introStatus;
  final GetAllStoresModel? stores;
  final String? errorMessage;
  final ApiStatus storeStatus;
  final GetStoreDetailsModel? storeDetails;
  final ApiStatus productStatus;
  final ProductDetailsResponseModel? productDetails;
  final ApiStatus sendProductReviewStatus;
  final String? sendProductReviewErrorMessage;
  final SearchResponseModel? searchResults;
  final ApiStatus searchStatus;
  final String? searchErrorMessage;
  final ApiStatus appVersionStatus;
  final AppVersionResponseModel? appVersion;
  final String? appVersionErrorMessage;

  const IntroState({
    required this.introStatus,
    this.stores,
    this.errorMessage,
    required this.storeStatus,
    this.storeDetails,
    required this.productStatus,
    this.productDetails,
    required this.sendProductReviewStatus,
    this.sendProductReviewErrorMessage,
    this.searchResults,
    required this.searchStatus,
    this.searchErrorMessage,
    required this.appVersionStatus,
    this.appVersion,
    this.appVersionErrorMessage,
  });

  factory IntroState.initial() => const IntroState(
    introStatus: ApiStatus.initial,
    stores: null,
    errorMessage: null,
    storeStatus: ApiStatus.initial,
    storeDetails: null,
    productStatus: ApiStatus.initial,
    productDetails: null,
    sendProductReviewStatus: ApiStatus.initial,
    sendProductReviewErrorMessage: null,
    searchResults: null,
    searchStatus: ApiStatus.initial,
    searchErrorMessage: null,
    appVersionStatus: ApiStatus.initial,
    appVersion: null,
    appVersionErrorMessage: null,
  );

  IntroState copyWith({
    ApiStatus? introStatus,
    GetAllStoresModel? stores,
    String? errorMessage,
    ApiStatus? storeStatus,
    GetStoreDetailsModel? storeDetails,
    ApiStatus? productStatus,
    ProductDetailsResponseModel? productDetails,
    ApiStatus? sendProductReviewStatus,
    String? sendProductReviewErrorMessage,
    SearchResponseModel? searchResults,
    ApiStatus? searchStatus,
    String? searchErrorMessage,
    ApiStatus? appVersionStatus,
    AppVersionResponseModel? appVersion,
    String? appVersionErrorMessage,
  }) {
    return IntroState(
      introStatus: introStatus ?? this.introStatus,
      stores: stores ?? this.stores,
      errorMessage: errorMessage ?? this.errorMessage,
      storeStatus: storeStatus ?? this.storeStatus,
      storeDetails: storeDetails ?? this.storeDetails,
      productStatus: productStatus ?? this.productStatus,
      productDetails: productDetails ?? this.productDetails,
      sendProductReviewStatus:
          sendProductReviewStatus ?? this.sendProductReviewStatus,
      sendProductReviewErrorMessage:
          sendProductReviewErrorMessage ?? this.sendProductReviewErrorMessage,
      searchResults: searchResults ?? this.searchResults,
      searchStatus: searchStatus ?? this.searchStatus,
      searchErrorMessage: searchErrorMessage ?? this.searchErrorMessage,
      appVersionStatus: appVersionStatus ?? this.appVersionStatus,
      appVersion: appVersion ?? this.appVersion,
      appVersionErrorMessage:
          appVersionErrorMessage ?? this.appVersionErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
    introStatus,
    stores,
    errorMessage,
    storeDetails,
    storeStatus,
    productStatus,
    productDetails,
    sendProductReviewStatus,
    sendProductReviewErrorMessage,
    searchResults,
    searchStatus,
    searchErrorMessage,
    appVersionStatus,
    appVersion,
    appVersionErrorMessage,
  ];
}
