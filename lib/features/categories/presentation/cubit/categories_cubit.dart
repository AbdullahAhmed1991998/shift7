import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shift7_app/core/errors/failures.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/features/categories/data/model/categories_model.dart';
import 'package:shift7_app/features/categories/data/model/categories_products_list_model.dart';
import 'package:shift7_app/features/categories/data/model/category_item_model.dart';
import 'package:shift7_app/features/categories/data/model/get_markets_categories_model.dart';
import 'package:shift7_app/features/categories/data/repos/categories_repo.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final CategoriesRepo repository;
  CategoriesCubit({required this.repository})
    : super(CategoriesState.initial());

  static const int _pageSize = 20;

  void _safeEmit(CategoriesState newState) {
    if (!isClosed) emit(newState);
  }

  Future<void> initCategories() async {
    if (state.status == ApiStatus.loading) return;
    _safeEmit(
      state.copyWith(
        status: ApiStatus.loading,
        errorMessage: '',
        categoriesItems: const <CategoryItemModel>[],
        categoriesCurrentPage: 1,
        categoriesHasMore: true,
        categoriesLoadingMore: false,
      ),
    );
    final result = await repository.getCategories(limit: _pageSize, page: 1);
    result.fold(
      (failure) {
        _safeEmit(
          state.copyWith(
            status: ApiStatus.error,
            errorMessage:
                (failure is ServerFailure)
                    ? failure.errorMessage
                    : failure.toString(),
          ),
        );
      },
      (categories) {
        final items = categories.data;
        _safeEmit(
          state.copyWith(
            status: ApiStatus.success,
            categories: categories,
            categoriesItems: items,
            categoriesHasMore: items.length >= _pageSize,
            categoriesCurrentPage: 1,
          ),
        );
      },
    );
  }

  Future<void> loadMoreCategories() async {
    if (state.status != ApiStatus.success) return;
    if (!state.categoriesHasMore) return;
    if (state.categoriesLoadingMore) return;

    final nextPage = state.categoriesCurrentPage + 1;
    _safeEmit(state.copyWith(categoriesLoadingMore: true));

    final result = await repository.getCategories(
      limit: _pageSize,
      page: nextPage,
    );
    result.fold(
      (failure) {
        _safeEmit(
          state.copyWith(
            categoriesLoadingMore: false,
            errorMessage:
                (failure is ServerFailure)
                    ? failure.errorMessage
                    : failure.toString(),
          ),
        );
      },
      (categories) {
        final newItems = categories.data;
        if (newItems.isEmpty) {
          _safeEmit(
            state.copyWith(
              categoriesLoadingMore: false,
              categoriesHasMore: false,
            ),
          );
          return;
        }
        final merged = [...state.categoriesItems, ...newItems];
        _safeEmit(
          state.copyWith(
            categories: categories,
            categoriesItems: merged,
            categoriesLoadingMore: false,
            categoriesCurrentPage: nextPage,
            categoriesHasMore: newItems.length >= _pageSize,
          ),
        );
      },
    );
  }

  Future<void> initProductsList(int categoryId) async {
    if (state.productsListCategoryId == categoryId &&
        state.productsListStatus == ApiStatus.success &&
        state.productsListItems.isNotEmpty) {
      return;
    }
    if (state.productsListStatus == ApiStatus.loading) return;

    _safeEmit(
      state.copyWith(
        productsListStatus: ApiStatus.loading,
        productsListErrorMessage: '',
        productsListItems: const [],
        productsListCurrentPage: 1,
        productsListHasMore: true,
        productsListCategoryId: categoryId,
        productsListLoadingMore: false,
      ),
    );

    final result = await repository.getCategoriesProductsList(
      categoryId: categoryId,
      limit: _pageSize,
      page: 1,
    );

    result.fold(
      (failure) {
        _safeEmit(
          state.copyWith(
            productsListStatus: ApiStatus.error,
            productsListErrorMessage:
                (failure is ServerFailure)
                    ? failure.errorMessage
                    : failure.toString(),
          ),
        );
      },
      (data) {
        final items = data.products;
        _safeEmit(
          state.copyWith(
            productsListStatus: ApiStatus.success,
            productsListData: data,
            productsListItems: items,
            productsListHasMore: items.length >= _pageSize,
            productsListCurrentPage: 1,
            productsListCategoryId: categoryId,
          ),
        );
      },
    );
  }

  Future<void> loadMoreProductsList() async {
    if (state.productsListStatus != ApiStatus.success) return;
    if (!state.productsListHasMore) return;
    if (state.productsListLoadingMore) return;
    if (state.productsListCategoryId == null) return;

    final categoryId = state.productsListCategoryId!;
    final nextPage = state.productsListCurrentPage + 1;

    _safeEmit(state.copyWith(productsListLoadingMore: true));

    final result = await repository.getCategoriesProductsList(
      categoryId: categoryId,
      limit: _pageSize,
      page: nextPage,
    );
    result.fold(
      (failure) {
        _safeEmit(
          state.copyWith(
            productsListLoadingMore: false,
            productsListErrorMessage:
                (failure is ServerFailure)
                    ? failure.errorMessage
                    : failure.toString(),
          ),
        );
      },
      (data) {
        final newItems = data.products;
        if (newItems.isEmpty) {
          _safeEmit(
            state.copyWith(
              productsListLoadingMore: false,
              productsListHasMore: false,
            ),
          );
          return;
        }
        final oldItems = state.productsListItems;
        final merged = [...oldItems, ...newItems];
        _safeEmit(
          state.copyWith(
            productsListData: data,
            productsListItems: merged,
            productsListLoadingMore: false,
            productsListCurrentPage: nextPage,
            productsListHasMore: newItems.length >= _pageSize,
            productsListCategoryId: categoryId,
          ),
        );
      },
    );
  }

  Future<void> initMarketsCategories() async {
    if (state.marketsCategoriesStatus == ApiStatus.loading) return;

    _safeEmit(
      state.copyWith(
        marketsCategoriesStatus: ApiStatus.loading,
        marketsCategoriesErrorMessage: '',
        marketsCategoriesItems: const <MarketCategoryData>[],
        marketsCategoriesCurrentPage: 1,
        marketsCategoriesHasMore: true,
        marketsCategoriesLoadingMore: false,
      ),
    );

    final result = await repository.getMarketsCategories(
      limit: _pageSize,
      page: 1,
    );

    result.fold(
      (failure) {
        _safeEmit(
          state.copyWith(
            marketsCategoriesStatus: ApiStatus.error,
            marketsCategoriesErrorMessage:
                (failure is ServerFailure)
                    ? failure.errorMessage
                    : failure.toString(),
          ),
        );
      },
      (response) {
        final markets = response.data;
        final hasMore = _anyMarketHasMore(markets);
        _safeEmit(
          state.copyWith(
            marketsCategoriesStatus: ApiStatus.success,
            marketsCategoriesData: response,
            marketsCategoriesItems: markets,
            marketsCategoriesHasMore: hasMore,
            marketsCategoriesCurrentPage: 1,
          ),
        );
      },
    );
  }

  Future<void> loadMoreMarketsCategories() async {
    if (state.marketsCategoriesStatus != ApiStatus.success) return;
    if (!state.marketsCategoriesHasMore) return;
    if (state.marketsCategoriesLoadingMore) return;

    final nextPage = state.marketsCategoriesCurrentPage + 1;
    _safeEmit(state.copyWith(marketsCategoriesLoadingMore: true));

    final result = await repository.getMarketsCategories(
      limit: _pageSize,
      page: nextPage,
    );

    result.fold(
      (failure) {
        _safeEmit(
          state.copyWith(
            marketsCategoriesLoadingMore: false,
            marketsCategoriesErrorMessage:
                (failure is ServerFailure)
                    ? failure.errorMessage
                    : failure.toString(),
          ),
        );
      },
      (response) {
        final incoming = response.data;
        if (incoming.isEmpty) {
          _safeEmit(
            state.copyWith(
              marketsCategoriesLoadingMore: false,
              marketsCategoriesHasMore: false,
            ),
          );
          return;
        }

        final merged = _mergeMarketsByName(
          state.marketsCategoriesItems,
          incoming,
        );
        final hasMore = _anyMarketHasMore(merged);

        _safeEmit(
          state.copyWith(
            marketsCategoriesData: response,
            marketsCategoriesItems: merged,
            marketsCategoriesLoadingMore: false,
            marketsCategoriesCurrentPage: nextPage,
            marketsCategoriesHasMore: hasMore,
          ),
        );
      },
    );
  }

  Future<void> refreshMarketsCategories() async {
    _safeEmit(
      state.copyWith(
        marketsCategoriesStatus: ApiStatus.initial,
        marketsCategoriesData: null,
        marketsCategoriesErrorMessage: '',
        marketsCategoriesItems: const <MarketCategoryData>[],
        marketsCategoriesCurrentPage: 0,
        marketsCategoriesHasMore: true,
        marketsCategoriesLoadingMore: false,
      ),
    );
    await initMarketsCategories();
  }

  Future<void> getCategories({required int limit, int page = 1}) async {
    _safeEmit(state.copyWith(status: ApiStatus.loading, errorMessage: ''));
    final result = await repository.getCategories(limit: limit, page: page);
    result.fold(
      (failure) {
        _safeEmit(
          state.copyWith(
            status: ApiStatus.error,
            errorMessage:
                (failure is ServerFailure)
                    ? failure.errorMessage
                    : failure.toString(),
          ),
        );
      },
      (categories) {
        _safeEmit(
          state.copyWith(
            status: ApiStatus.success,
            categories: categories,
            categoriesItems: categories.data,
            categoriesHasMore: categories.data.length >= limit,
          ),
        );
      },
    );
  }

  Future<void> getProductsList({
    required int categoryId,
    int limit = 20,
    int page = 1,
  }) async {
    _safeEmit(
      state.copyWith(
        productsListStatus: ApiStatus.loading,
        productsListErrorMessage: '',
      ),
    );
    final result = await repository.getCategoriesProductsList(
      categoryId: categoryId,
      limit: limit,
      page: page,
    );
    result.fold(
      (failure) {
        _safeEmit(
          state.copyWith(
            productsListStatus: ApiStatus.error,
            productsListErrorMessage:
                (failure is ServerFailure)
                    ? failure.errorMessage
                    : failure.toString(),
          ),
        );
      },
      (products) {
        final items = products.products;
        _safeEmit(
          state.copyWith(
            productsListStatus: ApiStatus.success,
            productsListData: products,
            productsListItems: items,
            productsListHasMore: items.length >= limit,
            productsListCurrentPage: page,
            productsListCategoryId: categoryId,
          ),
        );
      },
    );
  }

  List<MarketCategoryData> _mergeMarketsByName(
    List<MarketCategoryData> oldList,
    List<MarketCategoryData> newList,
  ) {
    final List<MarketCategoryData> result = List.of(oldList);
    final Map<String, int> indexByKey = {};
    for (int i = 0; i < result.length; i++) {
      indexByKey[_marketKey(result[i])] = i;
    }

    for (final inc in newList) {
      final key = _marketKey(inc);
      if (indexByKey.containsKey(key)) {
        final idx = indexByKey[key]!;
        final existing = result[idx];

        final List<CategoryModel> existingCats = List<CategoryModel>.from(
          existing.categories.data,
        );
        final Set<int> existingIds = existingCats.map((e) => e.id).toSet();
        final List<CategoryModel> incomingCats =
            inc.categories.data
                .where((c) => !existingIds.contains(c.id))
                .toList();
        final List<CategoryModel> mergedCats = [
          ...existingCats,
          ...incomingCats,
        ];

        final updatedCategories = existing.categories.copyWith(
          data: mergedCats,
          currentPage: inc.categories.currentPage,
          lastPage: inc.categories.lastPage,
          total: inc.categories.total,
          perPage: inc.categories.perPage,
        );

        result[idx] = existing.copyWith(categories: updatedCategories);
      } else {
        result.add(inc);
        indexByKey[key] = result.length - 1;
      }
    }
    return result;
  }

  String _marketKey(MarketCategoryData m) {
    final en = (m.marketNameEn).trim().toLowerCase();
    final ar = (m.marketNameAr).trim().toLowerCase();
    return en.isNotEmpty ? en : ar;
  }

  bool _anyMarketHasMore(List<MarketCategoryData> markets) {
    for (final m in markets) {
      final cur = m.categories.currentPage;
      final last = m.categories.lastPage;
      if (cur < last) return true;
    }
    return false;
  }
}
