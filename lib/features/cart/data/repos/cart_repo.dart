import 'package:dartz/dartz.dart';
import 'package:shift7_app/core/errors/failures.dart';
import 'package:shift7_app/features/cart/data/models/cart_details_response_model.dart';
import 'package:shift7_app/features/cart/data/models/checkout_cart_item_model.dart';
import 'package:shift7_app/features/cart/data/models/get_address_list_model.dart';
import 'package:shift7_app/features/cart/data/models/get_cart_details_model.dart';

abstract class CartRepo {
  Future<Either<Failures, dynamic>> addToCart({
    required int productId,
    required int quantity,
    int? variantId,
  });
  Future<Either<Failures, dynamic>> removeFromCart({
    required int productId,
    int? variantId,
  });
  Future<Either<Failures, dynamic>> clearCart();
  Future<Either<Failures, dynamic>> updateCartProduct({
    required int productId,
    required int quantity,
    int? variantId,
  });

  Future<Either<Failures, CartDetailsResponseModel>> getCart();

  Future<Either<Failures, dynamic>> checkout({
    int? addressId,
    String? coupon,
    required List<CheckoutCartItemModel> items,
  });

  Future<Either<Failures, GetAddressListModel>> getAddressList();

  Future<Either<Failures, GetCartDetailsModel>> getCartDetails({
    int? addressId,
    String? coupon,
    required List<CheckoutCartItemModel> cartItems,
  });
}
