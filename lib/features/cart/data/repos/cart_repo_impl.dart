import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shift7_app/core/errors/error_message.dart';
import 'package:shift7_app/core/errors/failures.dart';
import 'package:shift7_app/core/network/api_config.dart';
import 'package:shift7_app/core/network/api_service.dart';
import 'package:shift7_app/features/cart/data/models/cart_details_response_model.dart';
import 'package:shift7_app/features/cart/data/models/checkout_cart_item_model.dart';
import 'package:shift7_app/features/cart/data/models/get_address_list_model.dart';
import 'package:shift7_app/features/cart/data/models/get_cart_details_model.dart';
import 'package:shift7_app/features/cart/data/repos/cart_repo.dart';

class CartRepoImpl implements CartRepo {
  final ApiService apiService;
  CartRepoImpl({required this.apiService});
  @override
  Future<Either<Failures, dynamic>> addToCart({
    required int productId,
    required int quantity,
    int? variantId,
  }) async {
    try {
      final Map<String, dynamic> body = {
        "product_id": productId,
        "quantity": quantity,
      };
      if (variantId != null) {
        body["variant_id"] = variantId;
      }

      final response = await apiService.postData(
        endpoint: ApiConfig.addToCart,
        hasToken: true,
        data: body,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    } catch (_) {
      return Left(
        ServerFailure(errorMessage: 'Something went wrong. Please try again.'),
      );
    }
  }

  @override
  Future<Either<Failures, dynamic>> clearCart() async {
    try {
      final response = await apiService.postData(
        endpoint: ApiConfig.clearCart,
        hasToken: true,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, dynamic>> removeFromCart({
    required int productId,
    int? variantId,
  }) async {
    try {
      final response = await apiService.postData(
        endpoint: ApiConfig.removeFromCart,
        hasToken: true,
        data: {"product_id": productId, "variant_id": variantId},
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, dynamic>> updateCartProduct({
    required int productId,
    required int quantity,
    int? variantId,
  }) async {
    try {
      final response = await apiService.postData(
        endpoint: ApiConfig.updateCart,
        hasToken: true,
        data: {
          "product_id": productId,
          "quantity": quantity,
          "variant_id": variantId,
        },
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, CartDetailsResponseModel>> getCart() async {
    try {
      final response = await apiService.getData(
        endpoint: ApiConfig.getCart,
        hasToken: true,
        query: {},
        fromJson: (json) => CartDetailsResponseModel.fromJson(json),
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, dynamic>> checkout({
    int? addressId,
    String? coupon,
    required List<CheckoutCartItemModel> items,
  }) async {
    try {
      final itemsPayload = items
          .map(
            (e) => {
              'product_id': e.productId,
              'variant_id': e.variantId,
              'quantity': e.quantity,
            },
          )
          .toList(growable: false);

      final normalizedCoupon =
          (coupon?.trim().isEmpty ?? true) ? null : coupon!.trim();

      final body = <String, dynamic>{
        'address_id': addressId,
        'coupon': normalizedCoupon,
        'items': itemsPayload,
      }..removeWhere((k, v) => v == null);

      final response = await apiService.postData(
        endpoint: ApiConfig.checkout,
        hasToken: true,
        data: body,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, GetAddressListModel>> getAddressList() async {
    try {
      final response = await apiService.getData(
        endpoint: ApiConfig.getAddressList,
        hasToken: true,
        query: {},
        fromJson: (json) => GetAddressListModel.fromJson(json),
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failures, GetCartDetailsModel>> getCartDetails({
    int? addressId,
    String? coupon,
    required List<CheckoutCartItemModel> cartItems,
  }) async {
    try {
      final itemsPayload = cartItems
          .map(
            (e) => {
              'product_id': e.productId,
              'variant_id': e.variantId,
              'quantity': e.quantity,
            },
          )
          .toList(growable: false);

      final normalizedCoupon =
          (coupon?.trim().isEmpty ?? true) ? null : coupon!.trim();

      final Map<String, dynamic> body = {
        'address_id': addressId,
        'coupon': normalizedCoupon,
        'view': true,
        'items': itemsPayload,
      }..removeWhere((k, v) => v == null);

      final response = await apiService.postData(
        endpoint: ApiConfig.getCartDetails,
        hasToken: true,
        data: body,
        fromJson:
            (json) =>
                GetCartDetailsModel.fromJson(json as Map<String, dynamic>),
      );

      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(errorMessage: extractErrorMessage(e)));
    }
  }
}
