import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shift7_app/core/errors/error_message.dart';
import 'package:shift7_app/core/errors/failures.dart';
import 'package:shift7_app/core/network/api_config.dart';
import 'package:shift7_app/core/network/api_service.dart';
import 'package:shift7_app/features/favorite/data/models/get_favourite_model.dart';
import 'package:shift7_app/features/favorite/data/repos/fav_repo.dart';

class FavRepoImpl implements FavRepo {
  final ApiService apiService;
  FavRepoImpl({required this.apiService});

  @override
  Future<Either<Failures, WishlistResponseModel>> getFavList({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await apiService.getData(
        endpoint: ApiConfig.allFav,
        hasToken: true,
        query: {"page": page, "limit": limit},
        fromJson: (json) => WishlistResponseModel.fromJson(json),
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, dynamic>> isFavourite({
    required int productId,
  }) async {
    try {
      final response = await apiService.postData(
        endpoint: ApiConfig.setFav,
        hasToken: true,
        data: {"product_id": productId},
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }
}
