import 'cart_product_mini_model.dart';
import 'cart_variant_mini_model.dart';

class CartItemModel {
  final int productId;
  final int? variantId;
  final int quantity;
  final CartProductMiniModel product;
  final CartVariantMiniModel? variant;

  CartItemModel({
    required this.productId,
    required this.variantId,
    required this.quantity,
    required this.product,
    required this.variant,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['product_id'] ?? 0,
      variantId: json['variant_id'],
      quantity: json['quantity'] ?? 0,
      product: CartProductMiniModel.fromJson(json['product'] ?? const {}),
      variant:
          json['variant'] != null
              ? CartVariantMiniModel.fromJson(json['variant'])
              : null,
    );
  }
}
