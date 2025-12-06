class ProductVariantCombinationModel {
  final int variantId;
  final String? sku;
  final double price;
  final String color;
  final String size;

  ProductVariantCombinationModel({
    required this.variantId,
    this.sku,
    required this.price,
    required this.color,
    required this.size,
  });

  factory ProductVariantCombinationModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantCombinationModel(
      variantId: json['variant_id'],
      sku: json['sku'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      color: json['color'] ?? '',
      size: json['size'] ?? '',
    );
  }
}
