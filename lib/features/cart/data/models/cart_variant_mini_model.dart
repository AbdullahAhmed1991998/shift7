double _parseDouble(dynamic v) =>
    v != null ? (double.tryParse(v.toString()) ?? 0.0) : 0.0;

class CartVariantMiniModel {
  final int id;
  final int productId;
  final String sku;
  final double price;
  final String color;
  final String colorAr;
  final String size;
  final String sizeAr;

  CartVariantMiniModel({
    required this.id,
    required this.productId,
    required this.sku,
    required this.price,
    required this.color,
    required this.colorAr,
    required this.size,
    required this.sizeAr,
  });

  factory CartVariantMiniModel.fromJson(Map<String, dynamic> json) {
    return CartVariantMiniModel(
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      sku: json['sku'] ?? '',
      price: _parseDouble(json['price']),
      color: json['color'] ?? '',
      colorAr: json['اللون'] ?? '',
      size: json['size'] ?? '',
      sizeAr: json['مقاس'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'product_id': productId,
    'sku': sku,
    'price': price.toStringAsFixed(2),
    'color': color,
    'اللون': colorAr,
    'size': size,
    'مقاس': sizeAr,
  };
}
