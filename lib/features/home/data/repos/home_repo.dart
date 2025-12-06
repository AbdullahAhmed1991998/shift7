import 'package:dartz/dartz.dart';
import 'package:shift7_app/core/errors/failures.dart';
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

abstract class HomeRepo {
  Future<Either<Failures, SpecialOfferModel>> getSpecialOffers({
    required int storeId,
    required int limit,
    int? categoryId,
  });

  Future<Either<Failures, BestSellersModel>> getBestSeller({
    required int storeId,
    required int limit,
    int? categoryId,
  });

  Future<Either<Failures, NewArrivalsModel>> newArrival({
    required int storeId,
    required int limit,
    int? categoryId,
  });

  Future<Either<Failures, CustomTabsModel>> customTabs({
    required int id,
    required String tabType,
  });

  Future<Either<Failures, CustomTabsDetailsModel>> customTabsDetails({
    required int tabId,
    required int limit,
    required int page,
  });
  Future<Either<Failures, MediaLinksDetailsModel>> mediaLinksDetails({
    required int mediaId,
    required int limit,
    required int page,
  });
  Future<Either<Failures, BrandDataModel>> getBrandDetails({
    required int brandId,
    required int limit,
    required int page,
  });
  Future<Either<Failures, BrandsByCategoryModel>> getBrandsByCategory({
    required int limit,
    required int page,
    required int categoryId,
  });
  Future<Either<Failures, CategoriesByBrandModel>> getCategoriesByBrand({
    required int limit,
    required int page,
    required int brandId,
  });
  Future<Either<Failures, FilteredProductsModel>> getFilteredProducts({
    required int limit,
    required int page,
    int? minPrice,
    int? maxPrice,
    List<int>? brandIds,
    List<int>? categoryIds,
    List<int>? ratings,
  });
}
