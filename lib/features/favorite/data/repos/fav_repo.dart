import 'package:dartz/dartz.dart';
import 'package:shift7_app/core/errors/failures.dart';
import 'package:shift7_app/features/favorite/data/models/get_favourite_model.dart';

abstract class FavRepo {
  Future<Either<Failures, WishlistResponseModel>> getFavList({
    required int page,
    required int limit,
  });
  Future<Either<Failures, dynamic>> isFavourite({required int productId});
}
