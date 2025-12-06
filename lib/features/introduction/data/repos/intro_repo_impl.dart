import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shift7_app/core/errors/error_message.dart';
import 'package:shift7_app/core/errors/failures.dart';
import 'package:shift7_app/core/network/api_config.dart';
import 'package:shift7_app/core/network/api_service.dart';
import 'package:shift7_app/core/services/cache_helper_keys.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/features/app/data/models/product_details_response_model.dart';
import 'package:shift7_app/features/app/data/models/search_response_model.dart';
import 'package:shift7_app/features/introduction/data/model/app_version_model.dart';
import 'package:shift7_app/features/introduction/data/model/get_all_stores_model.dart';
import 'package:shift7_app/features/introduction/data/model/get_store_details_model.dart';
import 'package:shift7_app/features/introduction/data/repos/intro_repo.dart';

class IntroRepoImpl implements IntroRepo {
  final ApiService apiService;
  IntroRepoImpl({required this.apiService});

  @override
  Future<Either<Failures, GetAllStoresModel>> getAllStores() async {
    try {
      var response = await apiService.getData(
        endpoint: ApiConfig.intro,
        hasToken: false,
        query: {},
        fromJson: (json) => GetAllStoresModel.fromJson(json),
      );
      final defaultStore = response.data.firstWhere(
        (store) => store.isDefault == 1,
      );
      getIt<CacheHelper>().setData(
        key: CacheHelperKeys.mainStoreId,
        value: defaultStore.id.toInt(),
      );

      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, GetStoreDetailsModel>> getStoreDetails({
    required int storeId,
  }) async {
    try {
      var response = await apiService.getData(
        endpoint: "${ApiConfig.getStoreDetails}/$storeId",
        hasToken: false,
        query: {},
        fromJson: (json) => GetStoreDetailsModel.fromJson(json),
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, ProductDetailsResponseModel>> getProductItemDetails({
    required int productId,
  }) async {
    try {
      var response = await apiService.getData(
        endpoint: "${ApiConfig.getProduct}/$productId",
        hasToken: true,
        query: {},
        fromJson: (json) => ProductDetailsResponseModel.fromJson(json),
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, dynamic>> sendProductReview({
    required int productId,
    required String message,
    required int rate,
  }) async {
    try {
      var response = await apiService.postData(
        endpoint: ApiConfig.sendProductReview,
        hasToken: true,
        data: {
          "model_id": productId,
          "message": message,
          "rate": rate,
          "type": "product",
        },
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, SearchResponseModel>> getSearch({
    required String query,
  }) async {
    try {
      var response = await apiService.getData(
        endpoint: ApiConfig.search,
        hasToken: false,
        query: {"query": query},
        fromJson: (json) => SearchResponseModel.fromJson(json),
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, AppVersionResponseModel>> getAppVersion() async {
    try {
      var response = await apiService.getData(
        endpoint: ApiConfig.appVersion,
        hasToken: false,
        query: {},
        fromJson: (json) => AppVersionResponseModel.fromJson(json),
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }
}
