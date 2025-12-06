import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/features/app/data/models/product_details_response_model.dart';
import 'package:shift7_app/features/app/data/models/search_response_model.dart';
import 'package:shift7_app/features/introduction/data/model/app_version_model.dart';
import 'package:shift7_app/features/introduction/data/model/get_all_stores_model.dart';
import 'package:shift7_app/features/introduction/data/model/get_store_details_model.dart';
import 'package:shift7_app/features/introduction/data/repos/intro_repo.dart';

part 'intro_state.dart';

class IntroCubit extends Cubit<IntroState> {
  final IntroRepo introRepo;

  IntroCubit({required this.introRepo}) : super(IntroState.initial());

  void init() {
    emit(IntroState.initial());
  }

  void _safeEmit(IntroState newState) {
    if (!isClosed) emit(newState);
  }

  Future<void> getAllStores() async {
    _safeEmit(state.copyWith(introStatus: ApiStatus.loading));
    final result = await introRepo.getAllStores();
    result.fold(
      (failure) => _safeEmit(
        state.copyWith(
          introStatus: ApiStatus.error,
          errorMessage: failure.errorMessage,
        ),
      ),
      (stores) => _safeEmit(
        state.copyWith(introStatus: ApiStatus.success, stores: stores),
      ),
    );
  }

  Future<void> getStoresDetails({required int storeId}) async {
    _safeEmit(state.copyWith(storeStatus: ApiStatus.loading));
    final result = await introRepo.getStoreDetails(storeId: storeId);
    result.fold(
      (failure) => _safeEmit(
        state.copyWith(
          storeStatus: ApiStatus.error,
          errorMessage: failure.errorMessage,
        ),
      ),
      (stores) => _safeEmit(
        state.copyWith(storeStatus: ApiStatus.success, storeDetails: stores),
      ),
    );
  }

  Future<void> getProductDetails({required int productId}) async {
    _safeEmit(state.copyWith(productStatus: ApiStatus.loading));
    final result = await introRepo.getProductItemDetails(productId: productId);
    result.fold(
      (failure) => _safeEmit(
        state.copyWith(
          productStatus: ApiStatus.error,
          errorMessage: failure.errorMessage,
        ),
      ),
      (product) => _safeEmit(
        state.copyWith(
          productStatus: ApiStatus.success,
          productDetails: product,
        ),
      ),
    );
  }

  Future<void> sendProductReview({
    required int productId,
    required String message,
    required int rate,
  }) async {
    _safeEmit(state.copyWith(sendProductReviewStatus: ApiStatus.loading));
    final result = await introRepo.sendProductReview(
      productId: productId,
      message: message,
      rate: rate,
    );
    result.fold(
      (failure) => _safeEmit(
        state.copyWith(
          sendProductReviewStatus: ApiStatus.error,
          sendProductReviewErrorMessage: failure.errorMessage.toString(),
        ),
      ),
      (success) =>
          _safeEmit(state.copyWith(sendProductReviewStatus: ApiStatus.success)),
    );
  }

  Future<void> getSearch({required String query}) async {
    _safeEmit(state.copyWith(searchStatus: ApiStatus.loading));
    final result = await introRepo.getSearch(query: query);
    result.fold(
      (failure) => _safeEmit(
        state.copyWith(
          searchStatus: ApiStatus.error,
          searchErrorMessage: failure.errorMessage.toString(),
        ),
      ),
      (searchResults) => _safeEmit(
        state.copyWith(
          searchStatus: ApiStatus.success,
          searchResults: searchResults,
        ),
      ),
    );
  }

  Future<void> getAppVersion() async {
    _safeEmit(state.copyWith(appVersionStatus: ApiStatus.loading));
    final result = await introRepo.getAppVersion();
    result.fold(
      (failure) => _safeEmit(
        state.copyWith(
          appVersionStatus: ApiStatus.error,
          appVersionErrorMessage: failure.errorMessage,
        ),
      ),
      (version) => _safeEmit(
        state.copyWith(
          appVersionStatus: ApiStatus.success,
          appVersion: version,
          appVersionErrorMessage: null,
        ),
      ),
    );
  }
}
