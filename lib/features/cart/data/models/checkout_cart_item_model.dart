class CheckoutCartItemModel {
  final int productId;
  final int? variantId;
  final int quantity;

  CheckoutCartItemModel({
    required this.productId,
    this.variantId,
    required this.quantity,
  });
}
