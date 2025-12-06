import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shift7_app/core/errors/failures.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/features/app/data/models/filter_model.dart';
import 'package:shift7_app/features/home/data/model/brands_by_category_model.dart';
import 'package:shift7_app/features/home/data/model/categories_by_brand_model.dart';
import 'package:shift7_app/features/home/data/model/brand_data_model.dart'
    hide Brand;
import 'package:shift7_app/features/home/data/model/custom_tabs_details_model.dart';
import 'package:shift7_app/features/home/data/model/custom_tabs_model.dart';
import 'package:shift7_app/features/home/data/model/filtered_products_model.dart';
import 'package:shift7_app/features/home/data/model/media_links_details_model.dart';
import 'package:shift7_app/features/home/data/repos/home_repo.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;
  HomeCubit({required this.homeRepo}) : super(HomeState.init());

  static const int _initialLimit = 10;
  static const int _step = 10;

  void _safeEmit(HomeState newState) {
    if (!isClosed) emit(newState);
  }

  String _getCacheKey(int storeId, int categoryId) {
    return '$storeId-$categoryId';
  }

  Future<void> initSpecialOffers(int storeId, int categoryId) async {
    final key = _getCacheKey(storeId, categoryId);
    final existingData = state.specialOffersByCategory[key];

    if (state.currentStoreId != storeId) {
      _safeEmit(state.copyWith(currentStoreId: storeId));
    }

    if (existingData != null && existingData.isNotEmpty) {
      _safeEmit(state.copyWith(currentCategoryId: categoryId));
      return;
    }

    final loading = state.specialOffersLoadingByCategory[key] ?? false;
    if (loading) return;

    final updatedStatus = Map<String, ApiStatus>.from(
      state.specialOffersStatusByCategory,
    );
    updatedStatus[key] = ApiStatus.loading;

    final updatedLoading = Map<String, bool>.from(
      state.specialOffersLoadingByCategory,
    );
    updatedLoading[key] = false;

    _safeEmit(
      state.copyWith(
        specialOffersStatusByCategory: updatedStatus,
        specialOffersLoadingByCategory: updatedLoading,
        currentCategoryId: categoryId,
        currentStoreId: storeId,
      ),
    );

    final result = await homeRepo.getSpecialOffers(
      storeId: storeId,
      limit: _initialLimit,
      categoryId: categoryId,
    );

    result.fold(
      (failure) {
        final updatedStatus = Map<String, ApiStatus>.from(
          state.specialOffersStatusByCategory,
        );
        updatedStatus[key] = ApiStatus.error;

        _safeEmit(
          state.copyWith(
            specialOffersStatusByCategory: updatedStatus,
            message:
                (failure is ServerFailure)
                    ? failure.errorMessage
                    : failure.toString(),
          ),
        );
      },
      (data) {
        final items = (data.products) as List<dynamic>;

        final updatedData = Map<String, List<dynamic>>.from(
          state.specialOffersByCategory,
        );
        updatedData[key] = items;

        final updatedPage = Map<String, int>.from(
          state.specialOffersPageByCategory,
        );
        updatedPage[key] = _initialLimit;

        final updatedHasMore = Map<String, bool>.from(
          state.specialOffersHasMoreByCategory,
        );
        updatedHasMore[key] = items.length >= _initialLimit;

        final updatedStatus = Map<String, ApiStatus>.from(
          state.specialOffersStatusByCategory,
        );
        updatedStatus[key] = ApiStatus.success;

        _safeEmit(
          state.copyWith(
            specialOffersByCategory: updatedData,
            specialOffersPageByCategory: updatedPage,
            specialOffersHasMoreByCategory: updatedHasMore,
            specialOffersStatusByCategory: updatedStatus,
            currentCategoryId: categoryId,
            currentStoreId: storeId,
          ),
        );
      },
    );
  }

  Future<void> loadMoreSpecialOffers(int categoryId, int storeId) async {
    final key = _getCacheKey(storeId, categoryId);

    final hasMore = state.specialOffersHasMoreByCategory[key] ?? true;
    if (!hasMore) return;

    final loading = state.specialOffersLoadingByCategory[key] ?? false;
    if (loading) return;

    final currentLimit =
        state.specialOffersPageByCategory[key] ?? _initialLimit;
    final newLimit = currentLimit + _step;

    final updatedLoading = Map<String, bool>.from(
      state.specialOffersLoadingByCategory,
    );
    updatedLoading[key] = true;

    _safeEmit(state.copyWith(specialOffersLoadingByCategory: updatedLoading));

    final result = await homeRepo.getSpecialOffers(
      storeId: storeId,
      limit: newLimit,
      categoryId: categoryId,
    );

    result.fold(
      (failure) {
        final updatedLoading = Map<String, bool>.from(
          state.specialOffersLoadingByCategory,
        );
        updatedLoading[key] = false;

        _safeEmit(
          state.copyWith(
            specialOffersLoadingByCategory: updatedLoading,
            message:
                (failure is ServerFailure)
                    ? failure.errorMessage
                    : failure.toString(),
          ),
        );
      },
      (data) {
        final full = (data.products) as List<dynamic>;
        final old = state.specialOffersByCategory[key] ?? [];

        if (full.length <= old.length) {
          final updatedLoading = Map<String, bool>.from(
            state.specialOffersLoadingByCategory,
          );
          updatedLoading[key] = false;

          final updatedHasMore = Map<String, bool>.from(
            state.specialOffersHasMoreByCategory,
          );
          updatedHasMore[key] = false;

          final updatedPage = Map<String, int>.from(
            state.specialOffersPageByCategory,
          );
          updatedPage[key] = newLimit;

          _safeEmit(
            state.copyWith(
              specialOffersLoadingByCategory: updatedLoading,
              specialOffersHasMoreByCategory: updatedHasMore,
              specialOffersPageByCategory: updatedPage,
            ),
          );
          return;
        }

        final delta = full.sublist(old.length);
        final merged = [...old, ...delta];

        final updatedData = Map<String, List<dynamic>>.from(
          state.specialOffersByCategory,
        );
        updatedData[key] = merged;

        final updatedPage = Map<String, int>.from(
          state.specialOffersPageByCategory,
        );
        updatedPage[key] = newLimit;

        final updatedHasMore = Map<String, bool>.from(
          state.specialOffersHasMoreByCategory,
        );
        updatedHasMore[key] = full.length >= newLimit;

        final updatedLoading = Map<String, bool>.from(
          state.specialOffersLoadingByCategory,
        );
        updatedLoading[key] = false;

        _safeEmit(
          state.copyWith(
            specialOffersByCategory: updatedData,
            specialOffersPageByCategory: updatedPage,
            specialOffersHasMoreByCategory: updatedHasMore,
            specialOffersLoadingByCategory: updatedLoading,
          ),
        );
      },
    );
  }

  Future<void> initBestSeller(int storeId, int categoryId) async {
    final key = _getCacheKey(storeId, categoryId);
    final existingData = state.bestSellersByCategory[key];

    if (state.currentStoreId != storeId) {
      _safeEmit(state.copyWith(currentStoreId: storeId));
    }

    if (existingData != null && existingData.isNotEmpty) {
      _safeEmit(state.copyWith(currentCategoryId: categoryId));
      return;
    }

    final loading = state.bestSellersLoadingByCategory[key] ?? false;
    if (loading) return;

    final updatedStatus = Map<String, ApiStatus>.from(
      state.bestSellersStatusByCategory,
    );
    updatedStatus[key] = ApiStatus.loading;

    final updatedLoading = Map<String, bool>.from(
      state.bestSellersLoadingByCategory,
    );
    updatedLoading[key] = false;

    _safeEmit(
      state.copyWith(
        bestSellersStatusByCategory: updatedStatus,
        bestSellersLoadingByCategory: updatedLoading,
        currentCategoryId: categoryId,
        currentStoreId: storeId,
      ),
    );

    final result = await homeRepo.getBestSeller(
      storeId: storeId,
      limit: _initialLimit,
      categoryId: categoryId,
    );

    result.fold(
      (failure) {
        final updatedStatus = Map<String, ApiStatus>.from(
          state.bestSellersStatusByCategory,
        );
        updatedStatus[key] = ApiStatus.error;

        _safeEmit(
          state.copyWith(
            bestSellersStatusByCategory: updatedStatus,
            message:
                (failure is ServerFailure)
                    ? failure.errorMessage
                    : failure.toString(),
          ),
        );
      },
      (data) {
        final items = (data.data!.data) as List<dynamic>;

        final updatedData = Map<String, List<dynamic>>.from(
          state.bestSellersByCategory,
        );
        updatedData[key] = items;

        final updatedPage = Map<String, int>.from(
          state.bestSellersPageByCategory,
        );
        updatedPage[key] = _initialLimit;

        final updatedHasMore = Map<String, bool>.from(
          state.bestSellersHasMoreByCategory,
        );
        updatedHasMore[key] = items.length >= _initialLimit;

        final updatedStatus = Map<String, ApiStatus>.from(
          state.bestSellersStatusByCategory,
        );
        updatedStatus[key] = ApiStatus.success;

        _safeEmit(
          state.copyWith(
            bestSellersByCategory: updatedData,
            bestSellersPageByCategory: updatedPage,
            bestSellersHasMoreByCategory: updatedHasMore,
            bestSellersStatusByCategory: updatedStatus,
            currentCategoryId: categoryId,
            currentStoreId: storeId,
          ),
        );
      },
    );
  }

  Future<void> loadMoreBestSeller(int categoryId, int storeId) async {
    final key = _getCacheKey(storeId, categoryId);

    final hasMore = state.bestSellersHasMoreByCategory[key] ?? true;
    if (!hasMore) return;

    final loading = state.bestSellersLoadingByCategory[key] ?? false;
    if (loading) return;

    final currentLimit = state.bestSellersPageByCategory[key] ?? _initialLimit;
    final newLimit = currentLimit + _step;

    final updatedLoading = Map<String, bool>.from(
      state.bestSellersLoadingByCategory,
    );
    updatedLoading[key] = true;

    _safeEmit(state.copyWith(bestSellersLoadingByCategory: updatedLoading));

    final result = await homeRepo.getBestSeller(
      storeId: storeId,
      limit: newLimit,
      categoryId: categoryId,
    );

    result.fold(
      (failure) {
        final updatedLoading = Map<String, bool>.from(
          state.bestSellersLoadingByCategory,
        );
        updatedLoading[key] = false;

        _safeEmit(
          state.copyWith(
            bestSellersLoadingByCategory: updatedLoading,
            message:
                (failure is ServerFailure)
                    ? failure.errorMessage
                    : failure.toString(),
          ),
        );
      },
      (data) {
        final full = (data.data!.data) as List<dynamic>;
        final old = state.bestSellersByCategory[key] ?? [];

        if (full.length <= old.length) {
          final updatedLoading = Map<String, bool>.from(
            state.bestSellersLoadingByCategory,
          );
          updatedLoading[key] = false;

          final updatedHasMore = Map<String, bool>.from(
            state.bestSellersHasMoreByCategory,
          );
          updatedHasMore[key] = false;

          final updatedPage = Map<String, int>.from(
            state.bestSellersPageByCategory,
          );
          updatedPage[key] = newLimit;

          _safeEmit(
            state.copyWith(
              bestSellersLoadingByCategory: updatedLoading,
              bestSellersHasMoreByCategory: updatedHasMore,
              bestSellersPageByCategory: updatedPage,
            ),
          );
          return;
        }

        final delta = full.sublist(old.length);
        final merged = [...old, ...delta];

        final updatedData = Map<String, List<dynamic>>.from(
          state.bestSellersByCategory,
        );
        updatedData[key] = merged;

        final updatedPage = Map<String, int>.from(
          state.bestSellersPageByCategory,
        );
        updatedPage[key] = newLimit;

        final updatedHasMore = Map<String, bool>.from(
          state.bestSellersHasMoreByCategory,
        );
        updatedHasMore[key] = full.length >= newLimit;

        final updatedLoading = Map<String, bool>.from(
          state.bestSellersLoadingByCategory,
        );
        updatedLoading[key] = false;

        _safeEmit(
          state.copyWith(
            bestSellersByCategory: updatedData,
            bestSellersPageByCategory: updatedPage,
            bestSellersHasMoreByCategory: updatedHasMore,
            bestSellersLoadingByCategory: updatedLoading,
          ),
        );
      },
    );
  }

  Future<void> initNewArrivals(int storeId, int categoryId) async {
    final key = _getCacheKey(storeId, categoryId);
    final existingData = state.newArrivalsByCategory[key];

    if (state.currentStoreId != storeId) {
      _safeEmit(state.copyWith(currentStoreId: storeId));
    }

    if (existingData != null && existingData.isNotEmpty) {
      _safeEmit(state.copyWith(currentCategoryId: categoryId));
      return;
    }

    final loading = state.newArrivalsLoadingByCategory[key] ?? false;
    if (loading) return;

    final updatedStatus = Map<String, ApiStatus>.from(
      state.newArrivalsStatusByCategory,
    );
    updatedStatus[key] = ApiStatus.loading;

    final updatedLoading = Map<String, bool>.from(
      state.newArrivalsLoadingByCategory,
    );
    updatedLoading[key] = false;

    _safeEmit(
      state.copyWith(
        newArrivalsStatusByCategory: updatedStatus,
        newArrivalsLoadingByCategory: updatedLoading,
        currentCategoryId: categoryId,
        currentStoreId: storeId,
      ),
    );

    final result = await homeRepo.newArrival(
      storeId: storeId,
      limit: _initialLimit,
      categoryId: categoryId,
    );

    result.fold(
      (failure) {
        final updatedStatus = Map<String, ApiStatus>.from(
          state.newArrivalsStatusByCategory,
        );
        updatedStatus[key] = ApiStatus.error;

        _safeEmit(
          state.copyWith(
            newArrivalsStatusByCategory: updatedStatus,
            message:
                (failure is ServerFailure)
                    ? failure.errorMessage
                    : failure.toString(),
          ),
        );
      },
      (data) {
        final items = (data.products) as List<dynamic>;

        final updatedData = Map<String, List<dynamic>>.from(
          state.newArrivalsByCategory,
        );
        updatedData[key] = items;

        final updatedPage = Map<String, int>.from(
          state.newArrivalsPageByCategory,
        );
        updatedPage[key] = _initialLimit;

        final updatedHasMore = Map<String, bool>.from(
          state.newArrivalsHasMoreByCategory,
        );
        updatedHasMore[key] = items.length >= _initialLimit;

        final updatedStatus = Map<String, ApiStatus>.from(
          state.newArrivalsStatusByCategory,
        );
        updatedStatus[key] = ApiStatus.success;

        _safeEmit(
          state.copyWith(
            newArrivalsByCategory: updatedData,
            newArrivalsPageByCategory: updatedPage,
            newArrivalsHasMoreByCategory: updatedHasMore,
            newArrivalsStatusByCategory: updatedStatus,
            currentCategoryId: categoryId,
            currentStoreId: storeId,
          ),
        );
      },
    );
  }

  Future<void> loadMoreNewArrivals(int categoryId, int storeId) async {
    final key = _getCacheKey(storeId, categoryId);

    final hasMore = state.newArrivalsHasMoreByCategory[key] ?? true;
    if (!hasMore) return;

    final loading = state.newArrivalsLoadingByCategory[key] ?? false;
    if (loading) return;

    final currentLimit = state.newArrivalsPageByCategory[key] ?? _initialLimit;
    final newLimit = currentLimit + _step;

    final updatedLoading = Map<String, bool>.from(
      state.newArrivalsLoadingByCategory,
    );
    updatedLoading[key] = true;

    _safeEmit(state.copyWith(newArrivalsLoadingByCategory: updatedLoading));

    final result = await homeRepo.newArrival(
      storeId: storeId,
      limit: newLimit,
      categoryId: categoryId,
    );

    result.fold(
      (failure) {
        final updatedLoading = Map<String, bool>.from(
          state.newArrivalsLoadingByCategory,
        );
        updatedLoading[key] = false;

        _safeEmit(
          state.copyWith(
            newArrivalsLoadingByCategory: updatedLoading,
            message:
                (failure is ServerFailure)
                    ? failure.errorMessage
                    : failure.toString(),
          ),
        );
      },
      (data) {
        final full = (data.products) as List<dynamic>;
        final old = state.newArrivalsByCategory[key] ?? [];

        if (full.length <= old.length) {
          final updatedLoading = Map<String, bool>.from(
            state.newArrivalsLoadingByCategory,
          );
          updatedLoading[key] = false;

          final updatedHasMore = Map<String, bool>.from(
            state.newArrivalsHasMoreByCategory,
          );
          updatedHasMore[key] = false;

          final updatedPage = Map<String, int>.from(
            state.newArrivalsPageByCategory,
          );
          updatedPage[key] = newLimit;

          _safeEmit(
            state.copyWith(
              newArrivalsLoadingByCategory: updatedLoading,
              newArrivalsHasMoreByCategory: updatedHasMore,
              newArrivalsPageByCategory: updatedPage,
            ),
          );
          return;
        }

        final delta = full.sublist(old.length);
        final merged = [...old, ...delta];

        final updatedData = Map<String, List<dynamic>>.from(
          state.newArrivalsByCategory,
        );
        updatedData[key] = merged;

        final updatedPage = Map<String, int>.from(
          state.newArrivalsPageByCategory,
        );
        updatedPage[key] = newLimit;

        final updatedHasMore = Map<String, bool>.from(
          state.newArrivalsHasMoreByCategory,
        );
        updatedHasMore[key] = full.length >= newLimit;

        final updatedLoading = Map<String, bool>.from(
          state.newArrivalsLoadingByCategory,
        );
        updatedLoading[key] = false;

        _safeEmit(
          state.copyWith(
            newArrivalsByCategory: updatedData,
            newArrivalsPageByCategory: updatedPage,
            newArrivalsHasMoreByCategory: updatedHasMore,
            newArrivalsLoadingByCategory: updatedLoading,
          ),
        );
      },
    );
  }

  void clearAllCache() {
    _safeEmit(HomeState.init());
  }

  void clearStoreCache(int storeId) {
    final keysToRemove = <String>[];

    for (var key in state.specialOffersByCategory.keys) {
      if (key.startsWith('$storeId-')) {
        keysToRemove.add(key);
      }
    }

    final updatedSpecialOffers = Map<String, List<dynamic>>.from(
      state.specialOffersByCategory,
    );
    final updatedBestSellers = Map<String, List<dynamic>>.from(
      state.bestSellersByCategory,
    );
    final updatedNewArrivals = Map<String, List<dynamic>>.from(
      state.newArrivalsByCategory,
    );

    for (var key in keysToRemove) {
      updatedSpecialOffers.remove(key);
      updatedBestSellers.remove(key);
      updatedNewArrivals.remove(key);
    }

    _safeEmit(
      state.copyWith(
        specialOffersByCategory: updatedSpecialOffers,
        bestSellersByCategory: updatedBestSellers,
        newArrivalsByCategory: updatedNewArrivals,
      ),
    );
  }

  void clearCategoryCache(int storeId, int categoryId) {
    final key = _getCacheKey(storeId, categoryId);

    final updatedSpecialOffers = Map<String, List<dynamic>>.from(
      state.specialOffersByCategory,
    );
    updatedSpecialOffers.remove(key);

    final updatedBestSellers = Map<String, List<dynamic>>.from(
      state.bestSellersByCategory,
    );
    updatedBestSellers.remove(key);

    final updatedNewArrivals = Map<String, List<dynamic>>.from(
      state.newArrivalsByCategory,
    );
    updatedNewArrivals.remove(key);

    _safeEmit(
      state.copyWith(
        specialOffersByCategory: updatedSpecialOffers,
        bestSellersByCategory: updatedBestSellers,
        newArrivalsByCategory: updatedNewArrivals,
      ),
    );
  }

  Future<void> fetchCustomTabs({
    required int id,
    required String tabType,
  }) async {
    final key = '$id-$tabType';
    emit(
      state.copyWith(
        customTabsStatusByKey: {
          ...state.customTabsStatusByKey,
          key: ApiStatus.loading,
        },
      ),
    );
    final result = await homeRepo.customTabs(id: id, tabType: tabType);
    result.fold(
      (failure) => emit(
        state.copyWith(
          customTabsStatusByKey: {
            ...state.customTabsStatusByKey,
            key: ApiStatus.error,
          },
        ),
      ),
      (data) {
        emit(
          state.copyWith(
            customTabsStatusByKey: {
              ...state.customTabsStatusByKey,
              key: ApiStatus.success,
            },
            customTabsByKey: {...state.customTabsByKey, key: data.data.data},
          ),
        );
      },
    );
  }

  Future<void> fetchCustomTabsDetails(int tabId) async {
    _safeEmit(
      state.copyWith(
        customTabsDetailsStatus: ApiStatus.loading,
        customTabsDetailsList: const [],
        customTabsDetailsCurrentPage: 1,
        customTabsDetailsHasMore: true,
        customTabsDetailsLoadingMore: false,
      ),
    );

    final result = await homeRepo.customTabsDetails(
      tabId: tabId,
      page: 1,
      limit: _initialLimit,
    );

    result.fold(
      (failure) => _safeEmit(
        state.copyWith(
          customTabsDetailsStatus: ApiStatus.error,
          message:
              (failure is ServerFailure)
                  ? failure.errorMessage
                  : failure.toString(),
        ),
      ),
      (data) {
        if (data.data.isNotEmpty) {
          _safeEmit(
            state.copyWith(
              customTabsDetailsStatus: ApiStatus.success,
              customTabsDetailsModel: data,
              customTabsDetailsList: data.data,
              customTabsDetailsCurrentPage: 1,
              customTabsDetailsHasMore: data.data.length >= _initialLimit,
            ),
          );
        } else {
          _safeEmit(
            state.copyWith(
              customTabsDetailsStatus: ApiStatus.success,
              customTabsDetailsModel: data,
              customTabsDetailsList: const [],
              customTabsDetailsHasMore: false,
            ),
          );
        }
      },
    );
  }

  Future<void> loadMoreCustomTabsDetails() async {
    if (state.customTabsDetailsStatus != ApiStatus.success) return;
    if (!state.customTabsDetailsHasMore) return;
    if (state.customTabsDetailsLoadingMore) return;
    if (state.customTabsDetailsModel == null) return;

    final nextPage = state.customTabsDetailsCurrentPage + 1;

    final tabId = state.customTabsDetailsModel!.data[0].id;

    _safeEmit(state.copyWith(customTabsDetailsLoadingMore: true));

    final result = await homeRepo.customTabsDetails(
      tabId: tabId,
      page: nextPage,
      limit: _initialLimit,
    );

    result.fold(
      (failure) => _safeEmit(
        state.copyWith(
          customTabsDetailsLoadingMore: false,
          message:
              (failure is ServerFailure)
                  ? failure.errorMessage
                  : failure.toString(),
        ),
      ),
      (data) {
        if (data.data.isNotEmpty) {
          final newItems = data.data;
          final oldItems = state.customTabsDetailsList;
          final mergedItems = [...oldItems, ...newItems];

          _safeEmit(
            state.copyWith(
              customTabsDetailsModel: data,
              customTabsDetailsList: mergedItems,
              customTabsDetailsLoadingMore: false,
              customTabsDetailsCurrentPage: nextPage,
              customTabsDetailsHasMore: data.data.length >= _initialLimit,
            ),
          );
        } else {
          _safeEmit(
            state.copyWith(
              customTabsDetailsLoadingMore: false,
              customTabsDetailsHasMore: false,
            ),
          );
        }
      },
    );
  }

  Future<void> fetchMediaLinksDetails(int mediaId) async {
    _safeEmit(
      state.copyWith(
        mediaLinksDetailsStatus: ApiStatus.loading,
        mediaLinksDetailsList: const [],
        mediaLinksDetailsCurrentPage: 1,
        mediaLinksDetailsHasMore: true,
        mediaLinksDetailsLoadingMore: false,
      ),
    );

    final result = await homeRepo.mediaLinksDetails(
      mediaId: mediaId,
      page: 1,
      limit: _initialLimit,
    );

    result.fold(
      (failure) => _safeEmit(
        state.copyWith(
          mediaLinksDetailsStatus: ApiStatus.error,
          message:
              (failure is ServerFailure)
                  ? failure.errorMessage
                  : failure.toString(),
        ),
      ),
      (data) {
        if (data.data.isNotEmpty) {
          _safeEmit(
            state.copyWith(
              mediaLinksDetailsStatus: ApiStatus.success,
              mediaLinksDetailsModel: data,
              mediaLinksDetailsList: data.data,
              mediaLinksDetailsCurrentPage: 1,
              mediaLinksDetailsHasMore: data.data.length >= _initialLimit,
            ),
          );
        } else {
          _safeEmit(
            state.copyWith(
              mediaLinksDetailsStatus: ApiStatus.success,
              mediaLinksDetailsModel: data,
              mediaLinksDetailsList: const [],
              mediaLinksDetailsHasMore: false,
            ),
          );
        }
      },
    );
  }

  Future<void> loadMoreMediaLinksDetails() async {
    if (state.mediaLinksDetailsStatus != ApiStatus.success) return;
    if (!state.mediaLinksDetailsHasMore) return;
    if (state.mediaLinksDetailsLoadingMore) return;
    if (state.mediaLinksDetailsModel == null) return;

    final nextPage = state.mediaLinksDetailsCurrentPage + 1;

    final mediaId = state.mediaLinksDetailsModel!.data[0].id;

    _safeEmit(state.copyWith(mediaLinksDetailsLoadingMore: true));

    final result = await homeRepo.mediaLinksDetails(
      mediaId: mediaId,
      page: nextPage,
      limit: _initialLimit,
    );

    result.fold(
      (failure) => _safeEmit(
        state.copyWith(
          mediaLinksDetailsLoadingMore: false,
          message:
              (failure is ServerFailure)
                  ? failure.errorMessage
                  : failure.toString(),
        ),
      ),
      (data) {
        if (data.data.isNotEmpty) {
          final newItems = data.data;
          final oldItems = state.mediaLinksDetailsList;
          final mergedItems = [...oldItems, ...newItems];

          _safeEmit(
            state.copyWith(
              mediaLinksDetailsModel: data,
              mediaLinksDetailsList: mergedItems,
              mediaLinksDetailsLoadingMore: false,
              mediaLinksDetailsCurrentPage: nextPage,
              mediaLinksDetailsHasMore: data.data.length >= _initialLimit,
            ),
          );
        } else {
          _safeEmit(
            state.copyWith(
              mediaLinksDetailsLoadingMore: false,
              mediaLinksDetailsHasMore: false,
            ),
          );
        }
      },
    );
  }

  Future<void> initBrandDetails(int brandId) async {
    if (state.currentBrandId == brandId &&
        state.brandDetailsStatus == ApiStatus.success &&
        state.brandItems.isNotEmpty) {
      return;
    }

    if (state.brandDetailsStatus == ApiStatus.loading) return;

    _safeEmit(
      state.copyWith(
        brandDetailsStatus: ApiStatus.loading,
        brandItems: const [],
        brandCurrentPage: 1,
        brandHasMore: true,
        currentBrandId: brandId,
        brandLoadingMore: false,
      ),
    );

    final result = await homeRepo.getBrandDetails(
      brandId: brandId,
      limit: _initialLimit,
      page: 1,
    );

    result.fold(
      (failure) {
        _safeEmit(
          state.copyWith(
            brandDetailsStatus: ApiStatus.error,
            message:
                (failure is ServerFailure)
                    ? failure.errorMessage
                    : failure.toString(),
          ),
        );
      },
      (data) {
        final items = data.data?.products.data ?? [];

        _safeEmit(
          state.copyWith(
            brandDetailsStatus: ApiStatus.success,
            brandDataModel: data,
            brandItems: items,
            brandHasMore: items.length >= _initialLimit,
            brandCurrentPage: 1,
            currentBrandId: brandId,
          ),
        );
      },
    );
  }

  Future<void> loadMoreBrandDetails() async {
    if (state.brandDetailsStatus != ApiStatus.success) return;
    if (!state.brandHasMore) return;
    if (state.brandLoadingMore) return;
    if (state.currentBrandId == null) return;

    final brandId = state.currentBrandId!;
    final nextPage = state.brandCurrentPage + 1;

    _safeEmit(state.copyWith(brandLoadingMore: true));

    final result = await homeRepo.getBrandDetails(
      brandId: brandId,
      limit: _initialLimit,
      page: nextPage,
    );

    result.fold(
      (failure) {
        _safeEmit(
          state.copyWith(
            brandLoadingMore: false,
            message:
                (failure is ServerFailure)
                    ? failure.errorMessage
                    : failure.toString(),
          ),
        );
      },
      (data) {
        final newItems = data.data?.products.data ?? [];

        if (newItems.isEmpty) {
          _safeEmit(
            state.copyWith(brandLoadingMore: false, brandHasMore: false),
          );
          return;
        }

        final oldItems = state.brandItems;
        final merged = [...oldItems, ...newItems];

        _safeEmit(
          state.copyWith(
            brandDataModel: data,
            brandItems: merged,
            brandLoadingMore: false,
            brandCurrentPage: nextPage,
            brandHasMore: newItems.length >= _initialLimit,
            currentBrandId: brandId,
          ),
        );
      },
    );
  }

  Future<void> getBrandsByCategory({required int categoryId}) async {
    if (state.brandsState == ApiStatus.loading) return;

    _safeEmit(
      state.copyWith(
        brandsState: ApiStatus.loading,
        message: '',
        brandsList: const [],
        brandsCurrentPage: 1,
        brandsHasMore: true,
        brandsLoadingMore: false,
      ),
    );

    final result = await homeRepo.getBrandsByCategory(
      limit: 20,
      page: 1,
      categoryId: categoryId,
    );

    result.fold(
      (failure) => _safeEmit(
        state.copyWith(
          brandsState: ApiStatus.error,
          message:
              (failure is ServerFailure)
                  ? failure.errorMessage
                  : failure.toString(),
        ),
      ),
      (data) {
        final isSuccess = data.isSuccess ?? false;
        final message = data.message ?? '';

        if (isSuccess && data.hasData) {
          final brands = data.brands;
          final hasMore = data.hasNextPage;

          _safeEmit(
            state.copyWith(
              brandsState: ApiStatus.success,
              allBrandsModel: data,
              brandsList: brands,
              brandsCurrentPage: 1,
              brandsHasMore: hasMore,
            ),
          );
        } else {
          _safeEmit(
            state.copyWith(
              brandsState: ApiStatus.error,
              message: message.isNotEmpty ? message : 'Failed to load brands',
            ),
          );
        }
      },
    );
  }

  Future<void> loadMoreBrands({required int categoryId}) async {
    if (state.brandsState != ApiStatus.success) return;
    if (!state.brandsHasMore) return;
    if (state.brandsLoadingMore) return;

    final nextPage = state.brandsCurrentPage + 1;

    _safeEmit(state.copyWith(brandsLoadingMore: true));

    final result = await homeRepo.getBrandsByCategory(
      limit: 20,
      page: nextPage,
      categoryId: categoryId,
    );

    result.fold(
      (failure) => _safeEmit(
        state.copyWith(
          brandsLoadingMore: false,
          message:
              (failure is ServerFailure)
                  ? failure.errorMessage
                  : failure.toString(),
        ),
      ),
      (data) {
        final isSuccess = data.isSuccess ?? false;
        final message = data.message ?? '';

        if (isSuccess && data.hasData) {
          final newBrands = data.brands;
          final oldBrands = state.brandsList;
          final mergedBrands = [...oldBrands, ...newBrands];
          final hasMore = data.hasNextPage;

          _safeEmit(
            state.copyWith(
              allBrandsModel: data,
              brandsList: mergedBrands,
              brandsLoadingMore: false,
              brandsCurrentPage: nextPage,
              brandsHasMore: hasMore,
            ),
          );
        } else {
          _safeEmit(
            state.copyWith(
              brandsLoadingMore: false,
              brandsHasMore: false,
              message: message.isNotEmpty ? message : 'No more brands to load',
            ),
          );
        }
      },
    );
  }

  Future<void> getCategoriesByBrand({required int brandId}) async {
    if (state.categoriesState == ApiStatus.loading) return;

    _safeEmit(
      state.copyWith(
        categoriesState: ApiStatus.loading,
        message: '',
        categoriesList: const [],
        categoriesCurrentPage: 1,
        categoriesHasMore: true,
        categoriesLoadingMore: false,
      ),
    );

    final result = await homeRepo.getCategoriesByBrand(
      limit: 20,
      page: 1,
      brandId: brandId,
    );

    result.fold(
      (failure) => _safeEmit(
        state.copyWith(
          categoriesState: ApiStatus.error,
          message:
              (failure is ServerFailure)
                  ? failure.errorMessage
                  : failure.toString(),
        ),
      ),
      (data) {
        final isSuccess = data.isSuccess ?? false;
        final message = data.message ?? '';

        if (isSuccess && data.hasData) {
          final categories = data.categories;
          final hasMore = data.hasNextPage;

          _safeEmit(
            state.copyWith(
              categoriesState: ApiStatus.success,
              allCategoriesModel: data,
              categoriesList: categories,
              categoriesCurrentPage: 1,
              categoriesHasMore: hasMore,
            ),
          );
        } else {
          _safeEmit(
            state.copyWith(
              categoriesState: ApiStatus.error,
              message:
                  message.isNotEmpty ? message : 'Failed to load categories',
            ),
          );
        }
      },
    );
  }

  Future<void> loadMoreCategories({required int brandId}) async {
    if (state.categoriesState != ApiStatus.success) return;
    if (!state.categoriesHasMore) return;
    if (state.categoriesLoadingMore) return;

    final nextPage = state.categoriesCurrentPage + 1;

    _safeEmit(state.copyWith(categoriesLoadingMore: true));

    final result = await homeRepo.getCategoriesByBrand(
      limit: 20,
      page: nextPage,
      brandId: brandId,
    );

    result.fold(
      (failure) => _safeEmit(
        state.copyWith(
          categoriesLoadingMore: false,
          message:
              (failure is ServerFailure)
                  ? failure.errorMessage
                  : failure.toString(),
        ),
      ),
      (data) {
        final isSuccess = data.isSuccess ?? false;
        final message = data.message ?? '';

        if (isSuccess && data.hasData) {
          final newCategories = data.categories;
          final oldCategories = state.categoriesList;
          final mergedCategories = [...oldCategories, ...newCategories];
          final hasMore = data.hasNextPage;

          _safeEmit(
            state.copyWith(
              allCategoriesModel: data,
              categoriesList: mergedCategories,
              categoriesLoadingMore: false,
              categoriesCurrentPage: nextPage,
              categoriesHasMore: hasMore,
            ),
          );
        } else {
          _safeEmit(
            state.copyWith(
              categoriesLoadingMore: false,
              categoriesHasMore: false,
              message:
                  message.isNotEmpty ? message : 'No more categories to load',
            ),
          );
        }
      },
    );
  }

  void resetBrandsData() {
    _safeEmit(
      state.copyWith(
        brandsState: ApiStatus.initial,
        brandsList: const [],
        brandsCurrentPage: 1,
        brandsHasMore: true,
        brandsLoadingMore: false,
        allBrandsModel: null,
      ),
    );
  }

  void resetCategoriesData() {
    _safeEmit(
      state.copyWith(
        categoriesState: ApiStatus.initial,
        categoriesList: const [],
        categoriesCurrentPage: 1,
        categoriesHasMore: true,
        categoriesLoadingMore: false,
        allCategoriesModel: null,
      ),
    );
  }

  Future<void> initializeFiltersData({int? categoryId, int? brandId}) async {
    await Future.wait([
      if (categoryId != null) getBrandsByCategory(categoryId: categoryId),
      if (brandId != null) getCategoriesByBrand(brandId: brandId),
    ]);
  }

  Future<void> getFilteredProducts(FilterModel filterModel) async {
    if (state.filteredProductsState == ApiStatus.loading) return;

    _safeEmit(
      state.copyWith(
        filteredProductsState: ApiStatus.loading,
        message: '',
        filteredProductsList: const [],
        filteredProductsCurrentPage: 1,
        filteredProductsHasMore: true,
        filteredProductsLoadingMore: false,
        lastAppliedFilter: filterModel,
      ),
    );

    final result = await homeRepo.getFilteredProducts(
      limit: _initialLimit,
      page: 1,
      minPrice: filterModel.minPrice,
      maxPrice: filterModel.maxPrice,
      brandIds: filterModel.selectedBrand,
      categoryIds: filterModel.selectedCategory,
      ratings: filterModel.selectedRating,
    );

    result.fold(
      (failure) => _safeEmit(
        state.copyWith(
          filteredProductsState: ApiStatus.error,
          message:
              (failure is ServerFailure)
                  ? failure.errorMessage
                  : failure.toString(),
        ),
      ),
      (data) {
        if (data.hasData) {
          final products = data.products;
          _safeEmit(
            state.copyWith(
              filteredProductsState: ApiStatus.success,
              filteredProductsModel: data,
              filteredProductsList: products,
              filteredProductsCurrentPage: 1,
              filteredProductsHasMore: data.hasNextPage,
            ),
          );
        } else {
          _safeEmit(
            state.copyWith(
              filteredProductsState: ApiStatus.success,
              filteredProductsModel: data,
              filteredProductsList: const [],
              filteredProductsHasMore: false,
            ),
          );
        }
      },
    );
  }

  Future<void> loadMoreFilteredProducts() async {
    if (state.filteredProductsState != ApiStatus.success) return;
    if (!state.filteredProductsHasMore) return;
    if (state.filteredProductsLoadingMore) return;
    if (state.lastAppliedFilter == null) return;

    final nextPage = state.filteredProductsCurrentPage + 1;
    final filter = state.lastAppliedFilter!;

    _safeEmit(state.copyWith(filteredProductsLoadingMore: true));

    final result = await homeRepo.getFilteredProducts(
      limit: _initialLimit,
      page: nextPage,
      minPrice: filter.minPrice,
      maxPrice: filter.maxPrice,
      brandIds: filter.selectedBrand,
      categoryIds: filter.selectedCategory,
      ratings: filter.selectedRating,
    );

    result.fold(
      (failure) => _safeEmit(
        state.copyWith(
          filteredProductsLoadingMore: false,
          message:
              (failure is ServerFailure)
                  ? failure.errorMessage
                  : failure.toString(),
        ),
      ),
      (data) {
        if (data.hasData) {
          final newProducts = data.products;
          final oldProducts = state.filteredProductsList;
          final mergedProducts = [...oldProducts, ...newProducts];

          _safeEmit(
            state.copyWith(
              filteredProductsModel: data,
              filteredProductsList: mergedProducts,
              filteredProductsLoadingMore: false,
              filteredProductsCurrentPage: nextPage,
              filteredProductsHasMore: data.hasNextPage,
            ),
          );
        } else {
          _safeEmit(
            state.copyWith(
              filteredProductsLoadingMore: false,
              filteredProductsHasMore: false,
            ),
          );
        }
      },
    );
  }

  void clearFilteredProducts() {
    _safeEmit(
      state.copyWith(
        filteredProductsState: ApiStatus.initial,
        filteredProductsList: const [],
        filteredProductsModel: null,
        filteredProductsCurrentPage: 1,
        filteredProductsHasMore: true,
        filteredProductsLoadingMore: false,
        lastAppliedFilter: null,
      ),
    );
  }

  Future<void> refreshFilteredProducts() async {
    if (state.lastAppliedFilter != null) {
      await getFilteredProducts(state.lastAppliedFilter!);
    }
  }
}
