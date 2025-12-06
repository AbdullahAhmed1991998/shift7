import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shift7_app/core/errors/error_message.dart';
import 'package:shift7_app/core/errors/failures.dart';
import 'package:shift7_app/core/network/api_config.dart';
import 'package:shift7_app/core/network/api_service.dart';
import 'package:shift7_app/features/home/data/model/brands_by_category_model.dart';
import 'package:shift7_app/features/home/data/model/categories_by_brand_model.dart';
import 'package:shift7_app/features/home/data/model/best_seller_model.dart';
import 'package:shift7_app/features/home/data/model/brand_data_model.dart';
import 'package:shift7_app/features/home/data/model/custom_tabs_details_model.dart';
import 'package:shift7_app/features/home/data/model/custom_tabs_model.dart';
import 'package:shift7_app/features/home/data/model/filtered_products_model.dart';
import 'package:shift7_app/features/home/data/model/media_links_details_model.dart';
import 'package:shift7_app/features/home/data/model/new_arrivals_model.dart';
import 'package:shift7_app/features/home/data/model/special_offer_model.dart';
import 'package:shift7_app/features/home/data/repos/home_repo.dart';

class HomeRepoImpl implements HomeRepo {
  final ApiService apiService;
  HomeRepoImpl({required this.apiService});

  @override
  Future<Either<Failures, BestSellersModel>> getBestSeller({
    required int storeId,
    required int limit,
    int? categoryId,
  }) async {
    try {
      final response = await apiService.getData(
        endpoint: '${ApiConfig.bestSeller}/$storeId/$categoryId',
        hasToken: false,
        query: {'limit': limit},
        fromJson: (json) => BestSellersModel.fromJson(json),
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, SpecialOfferModel>> getSpecialOffers({
    required int storeId,
    required int limit,
    int? categoryId,
  }) async {
    try {
      final response = await apiService.getData(
        endpoint: '${ApiConfig.specialOffer}/$storeId/$categoryId',
        hasToken: false,
        query: {'limit': limit},
        fromJson: (json) => SpecialOfferModel.fromJson(json),
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, NewArrivalsModel>> newArrival({
    required int storeId,
    required int limit,
    int? categoryId,
  }) async {
    try {
      final response = await apiService.getData(
        endpoint: '${ApiConfig.newArrival}/$storeId/$categoryId',
        hasToken: false,
        query: {'limit': limit},
        fromJson: (json) => NewArrivalsModel.fromJson(json),
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, CustomTabsModel>> customTabs({
    required int id,
    required String tabType,
  }) async {
    try {
      final response = await apiService.getData(
        endpoint: '${ApiConfig.customTabs}/$tabType/$id',
        hasToken: false,
        query: {},
        fromJson: (json) => CustomTabsModel.fromJson(json),
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, CustomTabsDetailsModel>> customTabsDetails({
    required int tabId,
    required int limit,
    required int page,
  }) async {
    try {
      final response = await apiService.getData(
        endpoint: '${ApiConfig.customTabsDetails}/$tabId',
        hasToken: false,
        query: {},
        fromJson: (json) => CustomTabsDetailsModel.fromJson(json),
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, MediaLinksDetailsModel>> mediaLinksDetails({
    required int mediaId,
    required int limit,
    required int page,
  }) async {
    try {
      final response = await apiService.getData(
        endpoint: '${ApiConfig.mediaLinksDetails}/$mediaId',
        hasToken: false,
        query: {'limit': limit, 'page': page},
        fromJson: (json) => MediaLinksDetailsModel.fromJson(json),
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, BrandDataModel>> getBrandDetails({
    required int brandId,
    required int limit,
    required int page,
  }) async {
    try {
      final response = await apiService.getData(
        endpoint: '${ApiConfig.brandDetails}/$brandId',
        hasToken: false,
        query: {'limit': limit, 'page': page},
        fromJson: (json) => BrandDataModel.fromJson(json),
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, BrandsByCategoryModel>> getBrandsByCategory({
    required int limit,
    required int page,
    required int categoryId,
  }) async {
    try {
      final response = await apiService.getData(
        endpoint: '${ApiConfig.getBrandsByCategory}/$categoryId',
        hasToken: false,
        query: {'limit': limit, 'page': page},
        fromJson: (json) => BrandsByCategoryModel.fromJson(json),
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, CategoriesByBrandModel>> getCategoriesByBrand({
    required int limit,
    required int page,
    required int brandId,
  }) async {
    try {
      final response = await apiService.getData(
        endpoint: '${ApiConfig.getCategoriesByBrand}/$brandId',
        hasToken: false,
        query: {'limit': limit, 'page': page},
        fromJson: (json) => CategoriesByBrandModel.fromJson(json),
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, FilteredProductsModel>> getFilteredProducts({
    required int limit,
    required int page,
    int? minPrice,
    int? maxPrice,
    List<int>? brandIds,
    List<int>? categoryIds,
    List<int>? ratings,
  }) async {
    try {
      final response = await apiService.getData(
        endpoint: ApiConfig.getFilteredProducts,
        hasToken: false,
        query: {
          'limit': limit,
          'page': page,
          if (minPrice != null) 'min_price': minPrice,
          if (maxPrice != null) 'max_price': maxPrice,
          if (ratings != null) 'rate': ratings,
        },
        data: {
          if (brandIds != null) 'brand_ids': brandIds,
          if (categoryIds != null) 'category_ids': categoryIds,
        },
        fromJson: (json) => FilteredProductsModel.fromJson(json),
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }
}
