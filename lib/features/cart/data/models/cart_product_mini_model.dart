import 'package:shift7_app/features/app/data/models/product_item_media_model.dart';

double _parseDouble(dynamic v) =>
    v != null ? (double.tryParse(v.toString()) ?? 0.0) : 0.0;

class CartProductMiniModel {
  final int id;
  final String nameAr;
  final String nameEn;
  final double basePrice;
  final double totalDiscountsValue;
  final bool hasVariants;
  final String keyDefaultImage;
  final List<ProductMediaModel> media;

  CartProductMiniModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.basePrice,
    required this.totalDiscountsValue,
    required this.hasVariants,
    required this.keyDefaultImage,
    required this.media,
  });

  factory CartProductMiniModel.fromJson(Map<String, dynamic> json) {
    final mediaList =
        (json['media'] is List) ? json['media'] as List : const [];
    return CartProductMiniModel(
      id: json['id'] ?? 0,
      nameAr: json['name_ar'] ?? '',
      nameEn: json['name_en'] ?? '',
      basePrice: _parseDouble(json['base_price']),
      totalDiscountsValue: _parseDouble(json['total_discounts_value']),
      hasVariants: json['has_variants'] == 1 || json['has_variants'] == true,
      keyDefaultImage: json['key_default_image'] ?? '',
      media: mediaList.map((e) => ProductMediaModel.fromJson(e)).toList(),
    );
  }
}
