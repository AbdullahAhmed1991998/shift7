import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shift7_app/core/errors/error_message.dart';
import 'package:shift7_app/core/errors/failures.dart';
import 'package:shift7_app/core/network/api_config.dart';
import 'package:shift7_app/core/network/api_service.dart';
import 'package:shift7_app/core/services/cache_helper_keys.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/features/categories/data/model/categories_model.dart';
import 'package:shift7_app/features/categories/data/model/categories_products_list_model.dart';
import 'package:shift7_app/features/categories/data/model/get_markets_categories_model.dart';
import 'package:shift7_app/features/categories/data/repos/categories_repo.dart';

class CategoriesRepoImpl implements CategoriesRepo {
  final ApiService apiService;
  CategoriesRepoImpl({required this.apiService});

  @override
  Future<Either<Failures, CategoriesModel>> getCategories({
    required int limit,
    required int page,
  }) async {
    try {
      final response = await apiService.getData(
        endpoint:
            "${ApiConfig.allCategories}/${getIt<CacheHelper>().getData(key: CacheHelperKeys.mainStoreId)}",
        hasToken: false,
        query: {"limit": limit, "page": page},
        fromJson: (json) => CategoriesModel.fromJson(json),
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, CategoriesProductsListModel>>
  getCategoriesProductsList({
    required int categoryId,
    required int limit,
    required int page,
  }) async {
    try {
      final response = await apiService.getData(
        endpoint:
            "${ApiConfig.allCategoriesProducts}/$categoryId/${getIt<CacheHelper>().getData(key: CacheHelperKeys.mainStoreId)}",
        hasToken: false,
        query: {"limit": limit, "page": page},
        fromJson: (json) => CategoriesProductsListModel.fromJson(json),
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, GetMarketsCategoriesModel>> getMarketsCategories({
    required int limit,
    required int page,
  }) async {
    try {
      final response = await apiService.getData(
        endpoint:
            "${ApiConfig.marketCategories}/${getIt<CacheHelper>().getData(key: CacheHelperKeys.mainStoreId)}",
        hasToken: false,
        query: {"limit": limit, "page": page},
        fromJson: (json) => GetMarketsCategoriesModel.fromJson(json),
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }
}
