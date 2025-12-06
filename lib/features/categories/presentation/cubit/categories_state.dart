part of 'categories_cubit.dart';

class CategoriesState extends Equatable {
  final ApiStatus status;
  final CategoriesModel? categories;
  final String errorMessage;

  final ApiStatus productsListStatus;
  final CategoriesProductsListModel? productsListData;
  final String productsListErrorMessage;

  final ApiStatus marketsCategoriesStatus;
  final GetMarketsCategoriesModel? marketsCategoriesData;
  final String marketsCategoriesErrorMessage;

  final List<CategoryItemModel> categoriesItems;
  final bool categoriesLoadingMore;
  final bool categoriesHasMore;
  final int categoriesCurrentPage;

  final List<dynamic> productsListItems;
  final bool productsListLoadingMore;
  final bool productsListHasMore;
  final int productsListCurrentPage;
  final int? productsListCategoryId;

  final List<MarketCategoryData> marketsCategoriesItems;
  final bool marketsCategoriesLoadingMore;
  final bool marketsCategoriesHasMore;
  final int marketsCategoriesCurrentPage;

  const CategoriesState({
    this.status = ApiStatus.initial,
    this.categories,
    this.errorMessage = '',
    this.productsListStatus = ApiStatus.initial,
    this.productsListData,
    this.productsListErrorMessage = '',
    this.marketsCategoriesStatus = ApiStatus.initial,
    this.marketsCategoriesData,
    this.marketsCategoriesErrorMessage = '',
    this.categoriesItems = const <CategoryItemModel>[],
    this.categoriesLoadingMore = false,
    this.categoriesHasMore = true,
    this.categoriesCurrentPage = 0,
    this.productsListItems = const [],
    this.productsListLoadingMore = false,
    this.productsListHasMore = true,
    this.productsListCurrentPage = 0,
    this.productsListCategoryId,
    this.marketsCategoriesItems = const <MarketCategoryData>[],
    this.marketsCategoriesLoadingMore = false,
    this.marketsCategoriesHasMore = true,
    this.marketsCategoriesCurrentPage = 0,
  });

  factory CategoriesState.initial() {
    return const CategoriesState();
  }

  CategoriesState copyWith({
    ApiStatus? status,
    CategoriesModel? categories,
    String? errorMessage,
    ApiStatus? productsListStatus,
    CategoriesProductsListModel? productsListData,
    String? productsListErrorMessage,
    ApiStatus? marketsCategoriesStatus,
    GetMarketsCategoriesModel? marketsCategoriesData,
    String? marketsCategoriesErrorMessage,
    List<CategoryItemModel>? categoriesItems,
    bool? categoriesLoadingMore,
    bool? categoriesHasMore,
    int? categoriesCurrentPage,
    List<dynamic>? productsListItems,
    bool? productsListLoadingMore,
    bool? productsListHasMore,
    int? productsListCurrentPage,
    int? productsListCategoryId,
    List<MarketCategoryData>? marketsCategoriesItems,
    bool? marketsCategoriesLoadingMore,
    bool? marketsCategoriesHasMore,
    int? marketsCategoriesCurrentPage,
  }) {
    return CategoriesState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      errorMessage: errorMessage ?? this.errorMessage,
      productsListStatus: productsListStatus ?? this.productsListStatus,
      productsListData: productsListData ?? this.productsListData,
      productsListErrorMessage:
          productsListErrorMessage ?? this.productsListErrorMessage,
      marketsCategoriesStatus:
          marketsCategoriesStatus ?? this.marketsCategoriesStatus,
      marketsCategoriesData:
          marketsCategoriesData ?? this.marketsCategoriesData,
      marketsCategoriesErrorMessage:
          marketsCategoriesErrorMessage ?? this.marketsCategoriesErrorMessage,
      categoriesItems: categoriesItems ?? this.categoriesItems,
      categoriesLoadingMore:
          categoriesLoadingMore ?? this.categoriesLoadingMore,
      categoriesHasMore: categoriesHasMore ?? this.categoriesHasMore,
      categoriesCurrentPage:
          categoriesCurrentPage ?? this.categoriesCurrentPage,
      productsListItems: productsListItems ?? this.productsListItems,
      productsListLoadingMore:
          productsListLoadingMore ?? this.productsListLoadingMore,
      productsListHasMore: productsListHasMore ?? this.productsListHasMore,
      productsListCurrentPage:
          productsListCurrentPage ?? this.productsListCurrentPage,
      productsListCategoryId:
          productsListCategoryId ?? this.productsListCategoryId,
      marketsCategoriesItems:
          marketsCategoriesItems ?? this.marketsCategoriesItems,
      marketsCategoriesLoadingMore:
          marketsCategoriesLoadingMore ?? this.marketsCategoriesLoadingMore,
      marketsCategoriesHasMore:
          marketsCategoriesHasMore ?? this.marketsCategoriesHasMore,
      marketsCategoriesCurrentPage:
          marketsCategoriesCurrentPage ?? this.marketsCategoriesCurrentPage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    categories,
    errorMessage,
    productsListStatus,
    productsListData,
    productsListErrorMessage,
    marketsCategoriesStatus,
    marketsCategoriesData,
    marketsCategoriesErrorMessage,
    categoriesItems,
    categoriesLoadingMore,
    categoriesHasMore,
    categoriesCurrentPage,
    productsListItems,
    productsListLoadingMore,
    productsListHasMore,
    productsListCurrentPage,
    productsListCategoryId,
    marketsCategoriesItems,
    marketsCategoriesLoadingMore,
    marketsCategoriesHasMore,
    marketsCategoriesCurrentPage,
  ];
}
