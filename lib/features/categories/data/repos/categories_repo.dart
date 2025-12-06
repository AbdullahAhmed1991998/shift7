import 'package:dartz/dartz.dart';
import 'package:shift7_app/core/errors/failures.dart';
import 'package:shift7_app/features/categories/data/model/categories_model.dart';
import 'package:shift7_app/features/categories/data/model/categories_products_list_model.dart';
import 'package:shift7_app/features/categories/data/model/get_markets_categories_model.dart';

abstract class CategoriesRepo {
  Future<Either<Failures, CategoriesModel>> getCategories({
    required int limit,
    required int page,
  });
  Future<Either<Failures, CategoriesProductsListModel>>
  getCategoriesProductsList({
    required int categoryId,
    required int limit,
    required int page,
  });
  Future<Either<Failures, GetMarketsCategoriesModel>> getMarketsCategories({
    required int limit,
    required int page,
  });
}
