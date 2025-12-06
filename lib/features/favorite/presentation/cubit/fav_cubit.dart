import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shift7_app/core/errors/failures.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/features/favorite/data/models/get_favourite_model.dart';
import 'package:shift7_app/features/favorite/data/repos/fav_repo.dart';

part 'fav_state.dart';

class FavCubit extends Cubit<FavState> {
  final FavRepo repository;
  FavCubit({required this.repository}) : super(FavState.initial());

  void _safeEmit(FavState newState) {
    if (!isClosed) emit(newState);
  }

  static const int _initialLimit = 10;

  Future<void> initFavList() async {
    _safeEmit(
      state.copyWith(
        favStatus: ApiStatus.loading,
        errorMessage: '',
        favItems: const [],
        favCurrentPage: 1,
        favHasMore: true,
        favLoadingMore: false,
      ),
    );

    final result = await repository.getFavList(page: 1, limit: _initialLimit);

    result.fold(
      (failure) {
        _safeEmit(
          state.copyWith(
            favStatus: ApiStatus.error,
            errorMessage:
                (failure is ServerFailure)
                    ? failure.errorMessage.toString()
                    : failure.toString(),
          ),
        );
      },
      (favList) {
        final items = favList.data.data;
        _safeEmit(
          state.copyWith(
            favStatus: ApiStatus.success,
            favList: favList,
            favItems: items,
            favHasMore: items.length >= _initialLimit,
            favCurrentPage: 1,
          ),
        );
      },
    );
  }

  Future<void> loadMoreFavList() async {
    if (state.favStatus != ApiStatus.success) return;
    if (!state.favHasMore) return;
    if (state.favLoadingMore) return;

    final nextPage = state.favCurrentPage + 1;
    _safeEmit(state.copyWith(favLoadingMore: true));

    final result = await repository.getFavList(
      page: nextPage,
      limit: _initialLimit,
    );

    result.fold(
      (failure) {
        _safeEmit(
          state.copyWith(
            favLoadingMore: false,
            errorMessage:
                (failure is ServerFailure)
                    ? failure.errorMessage.toString()
                    : failure.toString(),
          ),
        );
      },
      (favList) {
        final newItems = favList.data.data;

        if (newItems.isEmpty) {
          _safeEmit(state.copyWith(favLoadingMore: false, favHasMore: false));
          return;
        }

        final oldItems = state.favItems;
        final merged = [...oldItems, ...newItems];

        _safeEmit(
          state.copyWith(
            favList: favList,
            favItems: merged,
            favLoadingMore: false,
            favCurrentPage: nextPage,
            favHasMore: newItems.length >= _initialLimit,
          ),
        );
      },
    );
  }

  Future<void> getFavList() async {
    _safeEmit(state.copyWith(favStatus: ApiStatus.loading, errorMessage: ''));
    final result = await repository.getFavList(page: 1, limit: _initialLimit);
    result.fold(
      (failure) {
        _safeEmit(
          state.copyWith(
            favStatus: ApiStatus.error,
            errorMessage:
                (failure is ServerFailure)
                    ? failure.errorMessage.toString()
                    : failure.toString(),
          ),
        );
      },
      (favList) {
        _safeEmit(
          state.copyWith(favStatus: ApiStatus.success, favList: favList),
        );
      },
    );
  }

  Future<void> setFav({required int productId}) async {
    final result = await repository.isFavourite(productId: productId);
    result.fold(
      (failure) {
        _safeEmit(
          state.copyWith(
            setFavStatus: ApiStatus.error,
            errorMessage:
                (failure is ServerFailure)
                    ? failure.errorMessage
                    : failure.toString(),
          ),
        );
      },
      (success) {
        _safeEmit(state.copyWith(setFavStatus: ApiStatus.success));
      },
    );
  }
}
