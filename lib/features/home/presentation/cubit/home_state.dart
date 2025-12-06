part of 'home_cubit.dart';

class HomeState extends Equatable {
  final ApiStatus customTabsState;
  final ApiStatus tabsDetailsStatus;
  final ApiStatus mediaLinksDetailsStatus;
  final ApiStatus brandDetailsStatus;
  final ApiStatus brandsState;
  final ApiStatus categoriesState;

  final CustomTabsModel? customTabsModel;
  final CustomTabsDetailsModel? customTabsDetailsModel;
  final MediaLinksDetailsModel? mediaLinksDetailsModel;
  final BrandDataModel? brandDataModel;
  final BrandsByCategoryModel? allBrandsModel;
  final CategoriesByBrandModel? allCategoriesModel;

  final Map<String, List<dynamic>> specialOffersByCategory;
  final Map<String, List<dynamic>> bestSellersByCategory;
  final Map<String, List<dynamic>> newArrivalsByCategory;

  final Map<String, int> specialOffersPageByCategory;
  final Map<String, int> bestSellersPageByCategory;
  final Map<String, int> newArrivalsPageByCategory;

  final Map<String, bool> specialOffersHasMoreByCategory;
  final Map<String, bool> bestSellersHasMoreByCategory;
  final Map<String, bool> newArrivalsHasMoreByCategory;

  final Map<String, bool> specialOffersLoadingByCategory;
  final Map<String, bool> bestSellersLoadingByCategory;
  final Map<String, bool> newArrivalsLoadingByCategory;

  final Map<String, ApiStatus> specialOffersStatusByCategory;
  final Map<String, ApiStatus> bestSellersStatusByCategory;
  final Map<String, ApiStatus> newArrivalsStatusByCategory;

  final int currentCategoryId;
  final int currentStoreId;

  final List<dynamic> brandItems;
  final bool brandLoadingMore;
  final bool brandHasMore;
  final int brandCurrentPage;
  final int? currentBrandId;

  final List<BrandData> brandsList;
  final bool brandsLoadingMore;
  final bool brandsHasMore;
  final int brandsCurrentPage;

  final List<CategoryData> categoriesList;
  final bool categoriesLoadingMore;
  final bool categoriesHasMore;
  final int categoriesCurrentPage;

  final String message;

  final FilteredProductsModel? filteredProductsModel;
  final List<FilteredProduct> filteredProductsList;
  final ApiStatus filteredProductsState;
  final int filteredProductsCurrentPage;
  final bool filteredProductsHasMore;
  final bool filteredProductsLoadingMore;
  final FilterModel? lastAppliedFilter;

  final List<dynamic> mediaLinksDetailsList;
  final int mediaLinksDetailsCurrentPage;
  final bool mediaLinksDetailsHasMore;
  final bool mediaLinksDetailsLoadingMore;

  final List<dynamic> customTabsDetailsList;
  final ApiStatus customTabsDetailsStatus;
  final int customTabsDetailsCurrentPage;
  final bool customTabsDetailsHasMore;
  final bool customTabsDetailsLoadingMore;

  final Map<String, List<CustomTab>> customTabsByKey;
  final Map<String, ApiStatus> customTabsStatusByKey;

  const HomeState({
    required this.customTabsState,
    required this.tabsDetailsStatus,
    required this.mediaLinksDetailsStatus,
    required this.brandDetailsStatus,
    required this.brandsState,
    required this.categoriesState,
    this.customTabsModel,
    this.customTabsDetailsModel,
    this.mediaLinksDetailsModel,
    this.brandDataModel,
    this.allBrandsModel,
    this.allCategoriesModel,
    this.specialOffersByCategory = const {},
    this.bestSellersByCategory = const {},
    this.newArrivalsByCategory = const {},
    this.specialOffersPageByCategory = const {},
    this.bestSellersPageByCategory = const {},
    this.newArrivalsPageByCategory = const {},
    this.specialOffersHasMoreByCategory = const {},
    this.bestSellersHasMoreByCategory = const {},
    this.newArrivalsHasMoreByCategory = const {},
    this.specialOffersLoadingByCategory = const {},
    this.bestSellersLoadingByCategory = const {},
    this.newArrivalsLoadingByCategory = const {},
    this.specialOffersStatusByCategory = const {},
    this.bestSellersStatusByCategory = const {},
    this.newArrivalsStatusByCategory = const {},
    this.currentCategoryId = 0,
    this.currentStoreId = 0,
    this.message = '',
    this.brandItems = const [],
    this.brandLoadingMore = false,
    this.brandHasMore = true,
    this.brandCurrentPage = 0,
    this.currentBrandId,
    this.brandsList = const [],
    this.brandsLoadingMore = false,
    this.brandsHasMore = true,
    this.brandsCurrentPage = 1,
    this.categoriesList = const [],
    this.categoriesLoadingMore = false,
    this.categoriesHasMore = true,
    this.categoriesCurrentPage = 1,
    this.filteredProductsModel,
    this.filteredProductsList = const [],
    this.filteredProductsState = ApiStatus.initial,
    this.filteredProductsCurrentPage = 1,
    this.filteredProductsHasMore = true,
    this.filteredProductsLoadingMore = false,
    this.lastAppliedFilter,
    this.mediaLinksDetailsList = const [],
    this.mediaLinksDetailsCurrentPage = 1,
    this.mediaLinksDetailsHasMore = true,
    this.mediaLinksDetailsLoadingMore = false,
    this.customTabsDetailsList = const [],
    this.customTabsDetailsStatus = ApiStatus.initial,
    this.customTabsDetailsCurrentPage = 1,
    this.customTabsDetailsHasMore = true,
    this.customTabsDetailsLoadingMore = false,
    this.customTabsByKey = const {},
    this.customTabsStatusByKey = const {},
  });

  factory HomeState.init() => const HomeState(
    customTabsState: ApiStatus.initial,
    tabsDetailsStatus: ApiStatus.initial,
    mediaLinksDetailsStatus: ApiStatus.initial,
    brandDetailsStatus: ApiStatus.initial,
    brandsState: ApiStatus.initial,
    categoriesState: ApiStatus.initial,
    brandDataModel: null,
    allBrandsModel: null,
    allCategoriesModel: null,
    customTabsModel: null,
    customTabsDetailsModel: null,
    mediaLinksDetailsModel: null,
    message: '',
    specialOffersByCategory: {},
    bestSellersByCategory: {},
    newArrivalsByCategory: {},
    specialOffersPageByCategory: {},
    bestSellersPageByCategory: {},
    newArrivalsPageByCategory: {},
    specialOffersHasMoreByCategory: {},
    bestSellersHasMoreByCategory: {},
    newArrivalsHasMoreByCategory: {},
    specialOffersLoadingByCategory: {},
    bestSellersLoadingByCategory: {},
    newArrivalsLoadingByCategory: {},
    specialOffersStatusByCategory: {},
    bestSellersStatusByCategory: {},
    newArrivalsStatusByCategory: {},
    currentCategoryId: 0,
    currentStoreId: 0,
    brandItems: [],
    brandLoadingMore: false,
    brandHasMore: true,
    brandCurrentPage: 0,
    currentBrandId: null,
    brandsList: [],
    brandsLoadingMore: false,
    brandsHasMore: true,
    brandsCurrentPage: 1,
    categoriesList: [],
    categoriesLoadingMore: false,
    categoriesHasMore: true,
    categoriesCurrentPage: 1,
    filteredProductsModel: null,
    filteredProductsList: [],
    filteredProductsState: ApiStatus.initial,
    filteredProductsCurrentPage: 1,
    filteredProductsHasMore: true,
    filteredProductsLoadingMore: false,
    lastAppliedFilter: null,
    mediaLinksDetailsList: [],
    mediaLinksDetailsCurrentPage: 1,
    mediaLinksDetailsHasMore: true,
    mediaLinksDetailsLoadingMore: false,
    customTabsDetailsList: [],
    customTabsDetailsStatus: ApiStatus.initial,
    customTabsDetailsCurrentPage: 1,
    customTabsDetailsHasMore: true,
    customTabsDetailsLoadingMore: false,
    customTabsByKey: {},
    customTabsStatusByKey: {},
  );

  String _getCacheKey(int storeId, int categoryId) {
    return '$storeId-$categoryId';
  }

  List<dynamic> getSpecialOffersForCategory(int categoryId, {int? storeId}) {
    final key = _getCacheKey(storeId ?? currentStoreId, categoryId);
    return specialOffersByCategory[key] ?? [];
  }

  List<dynamic> getBestSellersForCategory(int categoryId, {int? storeId}) {
    final key = _getCacheKey(storeId ?? currentStoreId, categoryId);
    return bestSellersByCategory[key] ?? [];
  }

  List<dynamic> getNewArrivalsForCategory(int categoryId, {int? storeId}) {
    final key = _getCacheKey(storeId ?? currentStoreId, categoryId);
    return newArrivalsByCategory[key] ?? [];
  }

  ApiStatus getSpecialOffersStatusForCategory(int categoryId, {int? storeId}) {
    final key = _getCacheKey(storeId ?? currentStoreId, categoryId);
    return specialOffersStatusByCategory[key] ?? ApiStatus.initial;
  }

  ApiStatus getBestSellersStatusForCategory(int categoryId, {int? storeId}) {
    final key = _getCacheKey(storeId ?? currentStoreId, categoryId);
    return bestSellersStatusByCategory[key] ?? ApiStatus.initial;
  }

  ApiStatus getNewArrivalsStatusForCategory(int categoryId, {int? storeId}) {
    final key = _getCacheKey(storeId ?? currentStoreId, categoryId);
    return newArrivalsStatusByCategory[key] ?? ApiStatus.initial;
  }

  bool isSpecialOffersLoadingForCategory(int categoryId, {int? storeId}) {
    final key = _getCacheKey(storeId ?? currentStoreId, categoryId);
    return specialOffersLoadingByCategory[key] ?? false;
  }

  bool isBestSellersLoadingForCategory(int categoryId, {int? storeId}) {
    final key = _getCacheKey(storeId ?? currentStoreId, categoryId);
    return bestSellersLoadingByCategory[key] ?? false;
  }

  bool isNewArrivalsLoadingForCategory(int categoryId, {int? storeId}) {
    final key = _getCacheKey(storeId ?? currentStoreId, categoryId);
    return newArrivalsLoadingByCategory[key] ?? false;
  }

  bool hasMoreSpecialOffersForCategory(int categoryId, {int? storeId}) {
    final key = _getCacheKey(storeId ?? currentStoreId, categoryId);
    return specialOffersHasMoreByCategory[key] ?? true;
  }

  bool hasMoreBestSellersForCategory(int categoryId, {int? storeId}) {
    final key = _getCacheKey(storeId ?? currentStoreId, categoryId);
    return bestSellersHasMoreByCategory[key] ?? true;
  }

  bool hasMoreNewArrivalsForCategory(int categoryId, {int? storeId}) {
    final key = _getCacheKey(storeId ?? currentStoreId, categoryId);
    return newArrivalsHasMoreByCategory[key] ?? true;
  }

  int getSpecialOffersPageForCategory(int categoryId, {int? storeId}) {
    final key = _getCacheKey(storeId ?? currentStoreId, categoryId);
    return specialOffersPageByCategory[key] ?? 20;
  }

  int getBestSellersPageForCategory(int categoryId, {int? storeId}) {
    final key = _getCacheKey(storeId ?? currentStoreId, categoryId);
    return bestSellersPageByCategory[key] ?? 20;
  }

  int getNewArrivalsPageForCategory(int categoryId, {int? storeId}) {
    final key = _getCacheKey(storeId ?? currentStoreId, categoryId);
    return newArrivalsPageByCategory[key] ?? 20;
  }

  HomeState copyWith({
    ApiStatus? customTabsState,
    ApiStatus? tabsDetailsStatus,
    ApiStatus? mediaLinksDetailsStatus,
    ApiStatus? brandDetailsStatus,
    ApiStatus? brandsState,
    ApiStatus? categoriesState,
    CustomTabsModel? customTabsModel,
    CustomTabsDetailsModel? customTabsDetailsModel,
    MediaLinksDetailsModel? mediaLinksDetailsModel,
    BrandDataModel? brandDataModel,
    BrandsByCategoryModel? allBrandsModel,
    CategoriesByBrandModel? allCategoriesModel,
    Map<String, List<dynamic>>? specialOffersByCategory,
    Map<String, List<dynamic>>? bestSellersByCategory,
    Map<String, List<dynamic>>? newArrivalsByCategory,
    Map<String, int>? specialOffersPageByCategory,
    Map<String, int>? bestSellersPageByCategory,
    Map<String, int>? newArrivalsPageByCategory,
    Map<String, bool>? specialOffersHasMoreByCategory,
    Map<String, bool>? bestSellersHasMoreByCategory,
    Map<String, bool>? newArrivalsHasMoreByCategory,
    Map<String, bool>? specialOffersLoadingByCategory,
    Map<String, bool>? bestSellersLoadingByCategory,
    Map<String, bool>? newArrivalsLoadingByCategory,
    Map<String, ApiStatus>? specialOffersStatusByCategory,
    Map<String, ApiStatus>? bestSellersStatusByCategory,
    Map<String, ApiStatus>? newArrivalsStatusByCategory,
    int? currentCategoryId,
    int? currentStoreId,
    String? message,
    List<dynamic>? brandItems,
    bool? brandLoadingMore,
    bool? brandHasMore,
    int? brandCurrentPage,
    int? currentBrandId,
    List<BrandData>? brandsList,
    bool? brandsLoadingMore,
    bool? brandsHasMore,
    int? brandsCurrentPage,
    List<CategoryData>? categoriesList,
    bool? categoriesLoadingMore,
    bool? categoriesHasMore,
    int? categoriesCurrentPage,
    FilteredProductsModel? filteredProductsModel,
    List<FilteredProduct>? filteredProductsList,
    ApiStatus? filteredProductsState,
    int? filteredProductsCurrentPage,
    bool? filteredProductsHasMore,
    bool? filteredProductsLoadingMore,
    FilterModel? lastAppliedFilter,
    List<dynamic>? mediaLinksDetailsList,
    int? mediaLinksDetailsCurrentPage,
    bool? mediaLinksDetailsHasMore,
    bool? mediaLinksDetailsLoadingMore,
    List<dynamic>? customTabsDetailsList,
    ApiStatus? customTabsDetailsStatus,
    int? customTabsDetailsCurrentPage,
    bool? customTabsDetailsHasMore,
    bool? customTabsDetailsLoadingMore,
    Map<String, List<CustomTab>>? customTabsByKey,
    Map<String, ApiStatus>? customTabsStatusByKey,
  }) {
    return HomeState(
      customTabsState: customTabsState ?? this.customTabsState,
      tabsDetailsStatus: tabsDetailsStatus ?? this.tabsDetailsStatus,
      mediaLinksDetailsStatus:
          mediaLinksDetailsStatus ?? this.mediaLinksDetailsStatus,
      brandDetailsStatus: brandDetailsStatus ?? this.brandDetailsStatus,
      brandsState: brandsState ?? this.brandsState,
      categoriesState: categoriesState ?? this.categoriesState,
      customTabsModel: customTabsModel ?? this.customTabsModel,
      customTabsDetailsModel:
          customTabsDetailsModel ?? this.customTabsDetailsModel,
      mediaLinksDetailsModel:
          mediaLinksDetailsModel ?? this.mediaLinksDetailsModel,
      brandDataModel: brandDataModel ?? this.brandDataModel,
      allBrandsModel: allBrandsModel ?? this.allBrandsModel,
      allCategoriesModel: allCategoriesModel ?? this.allCategoriesModel,
      specialOffersByCategory:
          specialOffersByCategory ?? this.specialOffersByCategory,
      bestSellersByCategory:
          bestSellersByCategory ?? this.bestSellersByCategory,
      newArrivalsByCategory:
          newArrivalsByCategory ?? this.newArrivalsByCategory,
      specialOffersPageByCategory:
          specialOffersPageByCategory ?? this.specialOffersPageByCategory,
      bestSellersPageByCategory:
          bestSellersPageByCategory ?? this.bestSellersPageByCategory,
      newArrivalsPageByCategory:
          newArrivalsPageByCategory ?? this.newArrivalsPageByCategory,
      specialOffersHasMoreByCategory:
          specialOffersHasMoreByCategory ?? this.specialOffersHasMoreByCategory,
      bestSellersHasMoreByCategory:
          bestSellersHasMoreByCategory ?? this.bestSellersHasMoreByCategory,
      newArrivalsHasMoreByCategory:
          newArrivalsHasMoreByCategory ?? this.newArrivalsHasMoreByCategory,
      specialOffersLoadingByCategory:
          specialOffersLoadingByCategory ?? this.specialOffersLoadingByCategory,
      bestSellersLoadingByCategory:
          bestSellersLoadingByCategory ?? this.bestSellersLoadingByCategory,
      newArrivalsLoadingByCategory:
          newArrivalsLoadingByCategory ?? this.newArrivalsLoadingByCategory,
      specialOffersStatusByCategory:
          specialOffersStatusByCategory ?? this.specialOffersStatusByCategory,
      bestSellersStatusByCategory:
          bestSellersStatusByCategory ?? this.bestSellersStatusByCategory,
      newArrivalsStatusByCategory:
          newArrivalsStatusByCategory ?? this.newArrivalsStatusByCategory,
      currentCategoryId: currentCategoryId ?? this.currentCategoryId,
      currentStoreId: currentStoreId ?? this.currentStoreId,
      message: message ?? this.message,
      brandItems: brandItems ?? this.brandItems,
      brandLoadingMore: brandLoadingMore ?? this.brandLoadingMore,
      brandHasMore: brandHasMore ?? this.brandHasMore,
      brandCurrentPage: brandCurrentPage ?? this.brandCurrentPage,
      currentBrandId: currentBrandId ?? this.currentBrandId,
      brandsList: brandsList ?? this.brandsList,
      brandsLoadingMore: brandsLoadingMore ?? this.brandsLoadingMore,
      brandsHasMore: brandsHasMore ?? this.brandsHasMore,
      brandsCurrentPage: brandsCurrentPage ?? this.brandsCurrentPage,
      categoriesList: categoriesList ?? this.categoriesList,
      categoriesLoadingMore:
          categoriesLoadingMore ?? this.categoriesLoadingMore,
      categoriesHasMore: categoriesHasMore ?? this.categoriesHasMore,
      categoriesCurrentPage:
          categoriesCurrentPage ?? this.categoriesCurrentPage,
      filteredProductsModel:
          filteredProductsModel ?? this.filteredProductsModel,
      filteredProductsList: filteredProductsList ?? this.filteredProductsList,
      filteredProductsState:
          filteredProductsState ?? this.filteredProductsState,
      filteredProductsCurrentPage:
          filteredProductsCurrentPage ?? this.filteredProductsCurrentPage,
      filteredProductsHasMore:
          filteredProductsHasMore ?? this.filteredProductsHasMore,
      filteredProductsLoadingMore:
          filteredProductsLoadingMore ?? this.filteredProductsLoadingMore,
      lastAppliedFilter: lastAppliedFilter ?? this.lastAppliedFilter,
      mediaLinksDetailsList:
          mediaLinksDetailsList ?? this.mediaLinksDetailsList,
      mediaLinksDetailsCurrentPage:
          mediaLinksDetailsCurrentPage ?? this.mediaLinksDetailsCurrentPage,
      mediaLinksDetailsHasMore:
          mediaLinksDetailsHasMore ?? this.mediaLinksDetailsHasMore,
      mediaLinksDetailsLoadingMore:
          mediaLinksDetailsLoadingMore ?? this.mediaLinksDetailsLoadingMore,
      customTabsDetailsList:
          customTabsDetailsList ?? this.customTabsDetailsList,
      customTabsDetailsStatus:
          customTabsDetailsStatus ?? this.customTabsDetailsStatus,
      customTabsDetailsCurrentPage:
          customTabsDetailsCurrentPage ?? this.customTabsDetailsCurrentPage,
      customTabsDetailsHasMore:
          customTabsDetailsHasMore ?? this.customTabsDetailsHasMore,
      customTabsDetailsLoadingMore:
          customTabsDetailsLoadingMore ?? this.customTabsDetailsLoadingMore,
      customTabsByKey: customTabsByKey ?? this.customTabsByKey,
      customTabsStatusByKey:
          customTabsStatusByKey ?? this.customTabsStatusByKey,
    );
  }

  @override
  List<Object?> get props => [
    customTabsState,
    tabsDetailsStatus,
    mediaLinksDetailsStatus,
    brandDetailsStatus,
    brandsState,
    categoriesState,
    customTabsModel,
    customTabsDetailsModel,
    mediaLinksDetailsModel,
    brandDataModel,
    allBrandsModel,
    allCategoriesModel,
    specialOffersByCategory,
    bestSellersByCategory,
    newArrivalsByCategory,
    specialOffersPageByCategory,
    bestSellersPageByCategory,
    newArrivalsPageByCategory,
    specialOffersHasMoreByCategory,
    bestSellersHasMoreByCategory,
    newArrivalsHasMoreByCategory,
    specialOffersLoadingByCategory,
    bestSellersLoadingByCategory,
    newArrivalsLoadingByCategory,
    specialOffersStatusByCategory,
    bestSellersStatusByCategory,
    newArrivalsStatusByCategory,
    currentCategoryId,
    currentStoreId,
    message,
    brandItems,
    brandLoadingMore,
    brandHasMore,
    brandCurrentPage,
    currentBrandId,
    brandsList,
    brandsLoadingMore,
    brandsHasMore,
    brandsCurrentPage,
    categoriesList,
    categoriesLoadingMore,
    categoriesHasMore,
    categoriesCurrentPage,
    filteredProductsModel,
    filteredProductsList,
    filteredProductsState,
    filteredProductsCurrentPage,
    filteredProductsHasMore,
    filteredProductsLoadingMore,
    lastAppliedFilter,
    mediaLinksDetailsList,
    mediaLinksDetailsCurrentPage,
    mediaLinksDetailsHasMore,
    mediaLinksDetailsLoadingMore,
    customTabsDetailsList,
    customTabsDetailsStatus,
    customTabsDetailsCurrentPage,
    customTabsDetailsHasMore,
    customTabsDetailsLoadingMore,
    customTabsByKey,
    customTabsStatusByKey,
  ];

  List<Map<String, dynamic>> get brandsForFilter {
    return brandsList.map((brand) => brand.toFilterMap()).toList();
  }

  List<Map<String, dynamic>> get categoriesForFilter {
    return categoriesList.map((category) => category.toFilterMap()).toList();
  }

  bool get hasBrandsData => brandsList.isNotEmpty;
  bool get hasCategoriesData => categoriesList.isNotEmpty;

  bool get canLoadMoreBrands => brandsHasMore && !brandsLoadingMore;
  bool get canLoadMoreCategories => categoriesHasMore && !categoriesLoadingMore;

  bool get hasFilteredProductsData => filteredProductsList.isNotEmpty;
  bool get canLoadMoreFilteredProducts =>
      filteredProductsHasMore && !filteredProductsLoadingMore;
  bool get hasActiveFilter =>
      lastAppliedFilter != null && lastAppliedFilter!.hasFilters;
  int get totalFilteredProducts => filteredProductsModel?.totalProducts ?? 0;
  bool get canLoadMoreMediaLinksDetails =>
      mediaLinksDetailsHasMore && !mediaLinksDetailsLoadingMore;
  bool get canLoadMoreCustomTabsDetails =>
      customTabsDetailsHasMore && !customTabsDetailsLoadingMore;
}
