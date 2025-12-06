import 'package:dartz/dartz.dart';
import 'package:shift7_app/core/errors/failures.dart';
import 'package:shift7_app/features/app/data/models/product_details_response_model.dart';
import 'package:shift7_app/features/app/data/models/search_response_model.dart';
import 'package:shift7_app/features/introduction/data/model/app_version_model.dart';
import 'package:shift7_app/features/introduction/data/model/get_all_stores_model.dart';
import 'package:shift7_app/features/introduction/data/model/get_store_details_model.dart';

abstract class IntroRepo {
  Future<Either<Failures, GetAllStoresModel>> getAllStores();
  Future<Either<Failures, GetStoreDetailsModel>> getStoreDetails({
    required int storeId,
  });
  Future<Either<Failures, ProductDetailsResponseModel>> getProductItemDetails({
    required int productId,
  });
  Future<Either<Failures, dynamic>> sendProductReview({
    required int productId,
    required String message,
    required int rate,
  });
  Future<Either<Failures, SearchResponseModel>> getSearch({
    required String query,
  });

  Future<Either<Failures, AppVersionResponseModel>> getAppVersion();
}
