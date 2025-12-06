class ProductVariantModel {
  final int id;
  final int productId;
  final String skuEn;
  final String skuAr;
  final double price;
  final double costPrice;

  ProductVariantModel({
    required this.id,
    required this.productId,
    required this.skuEn,
    required this.skuAr,
    required this.price,
    required this.costPrice,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) =>
        value != null ? double.tryParse(value.toString()) ?? 0.0 : 0.0;

    return ProductVariantModel(
      id: json['id'],
      productId: json['product_id'],
      skuEn: json['sku_en'] ?? '',
      skuAr: json['sku_ar'] ?? '',
      price: parseDouble(json['price']),
      costPrice: parseDouble(json['cost_price']),
    );
  }
}
