import 'package:shift7_app/features/app/data/models/search_media_model.dart';

class SearchProductModel {
  final int id;
  final int storeId;
  final int categoryId;
  final int? brandId;
  final int? modelId;
  final String? qbItemId;
  final String nameAr;
  final String nameEn;
  final String? subNameAr;
  final String? subNameEn;
  final String? descriptionAr;
  final String? descriptionEn;
  final String? sku;
  final String? code;
  final String slug;
  final bool isDisplayed;
  final double basePrice;
  final double costPrice;
  final double tax;
  final bool isStock;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool hasVariants;
  final String keyDefaultImage;
  final List<SearchMediaModel> media;

  SearchProductModel({
    required this.id,
    required this.storeId,
    required this.categoryId,
    this.brandId,
    this.modelId,
    this.qbItemId,
    required this.nameAr,
    required this.nameEn,
    this.subNameAr,
    this.subNameEn,
    this.descriptionAr,
    this.descriptionEn,
    this.sku,
    this.code,
    required this.slug,
    required this.isDisplayed,
    required this.basePrice,
    required this.costPrice,
    required this.tax,
    required this.isStock,
    this.createdAt,
    this.updatedAt,
    required this.hasVariants,
    required this.keyDefaultImage,
    required this.media,
  });

  factory SearchProductModel.fromJson(Map<String, dynamic> json) {
    return SearchProductModel(
      id: json['id'] ?? 0,
      storeId: json['store_id'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      brandId: json['brand_id'],
      modelId: json['model_id'],
      qbItemId: json['qb_item_id'],
      nameAr: json['name_ar'] ?? '',
      nameEn: json['name_en'] ?? '',
      subNameAr: json['sub_name_ar'],
      subNameEn: json['sub_name_en'],
      descriptionAr: json['description_ar'],
      descriptionEn: json['description_en'],
      sku: json['sku'],
      code: json['code'],
      slug: json['slug'] ?? '',
      isDisplayed: (json['is_displayed'] ?? 0) == 1,
      basePrice: double.tryParse(json['base_price']?.toString() ?? '0') ?? 0.0,
      costPrice: double.tryParse(json['cost_price']?.toString() ?? '0') ?? 0.0,
      tax: double.tryParse(json['tax']?.toString() ?? '0') ?? 0.0,
      isStock: (json['is_stock'] ?? 0) == 1,
      createdAt:
          json['created_at'] != null
              ? DateTime.tryParse(json['created_at'])
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.tryParse(json['updated_at'])
              : null,
      hasVariants: json['has_variants'] ?? false,
      keyDefaultImage: json['key_default_image'] ?? '',
      media:
          json['media'] != null
              ? (json['media'] as List)
                  .map((mediaJson) => SearchMediaModel.fromJson(mediaJson))
                  .toList()
              : [],
    );
  }
}
