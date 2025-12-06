import 'package:shift7_app/features/app/data/models/product_item_category_model.dart';
import 'package:shift7_app/features/app/data/models/product_item_media_model.dart';
import 'package:shift7_app/features/app/data/models/product_reviews_model.dart';
import 'package:shift7_app/features/app/data/models/product_variant_model.dart';

class ProductItemModel {
  final int id;
  final int? isStockAvailable;
  final int? storeId;
  final int? categoryId;
  final int? brandId;
  final int? modelId;
  final String nameAr;
  final String nameEn;
  final String? subNameAr;
  final String? subNameEn;
  final String? descriptionAr;
  final String? descriptionEn;
  final String? code;
  final String slug;
  final double basePrice;
  final double costPrice;
  final double tax;
  final bool isDisplayed;
  final bool hasVariants;
  final bool isWished;
  final bool inCart;
  final String? keyDefaultImage;
  final String? totalSales;
  final List<ProductMediaModel> media;
  final List<ProductVariantModel> variants;
  final List<ProductReviewsModel> reviews;
  final ProductItemCategoryModel? category;
  final int? isFreeShipping;
  final double totalDiscountsValue;
  final double? totalRating;

  ProductItemModel({
    required this.id,
    this.isStockAvailable,
    this.storeId,
    this.categoryId,
    this.brandId,
    this.modelId,
    required this.nameAr,
    required this.nameEn,
    this.subNameAr,
    this.subNameEn,
    this.descriptionAr,
    this.descriptionEn,
    this.code,
    required this.slug,
    required this.basePrice,
    required this.costPrice,
    required this.tax,
    required this.isDisplayed,
    required this.hasVariants,
    required this.isWished,
    required this.inCart,
    this.keyDefaultImage,
    this.totalSales,
    required this.media,
    required this.variants,
    required this.reviews,
    this.category,
    this.isFreeShipping,
    required this.totalDiscountsValue,
    this.totalRating,
  });

  factory ProductItemModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0.0;
    }

    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toInt();
      return int.tryParse(value.toString()) ?? 0;
    }

    bool parseBool(dynamic value) {
      if (value is bool) return value;
      if (value is num) return value != 0;
      if (value is String) {
        final v = value.toLowerCase();
        return v == 'true' || v == '1';
      }
      return false;
    }

    final rawDiscount = json['total_discounts_value'];
    final totalDiscount = parseDouble(rawDiscount);

    return ProductItemModel(
      id: parseInt(json['id']),
      isStockAvailable:
          json['is_stock'] != null ? parseInt(json['is_stock']) : null,
      storeId: json['store_id'] != null ? parseInt(json['store_id']) : null,
      categoryId:
          json['category_id'] != null ? parseInt(json['category_id']) : null,
      brandId: json['brand_id'] != null ? parseInt(json['brand_id']) : null,
      modelId: json['model_id'] != null ? parseInt(json['model_id']) : null,
      nameAr: json['name_ar']?.toString() ?? '',
      nameEn: json['name_en']?.toString() ?? '',
      subNameAr: json['sub_name_ar']?.toString(),
      subNameEn: json['sub_name_en']?.toString(),
      descriptionAr: json['description_ar']?.toString(),
      descriptionEn: json['description_en']?.toString(),
      code: json['code']?.toString(),
      slug: json['slug']?.toString() ?? '',
      basePrice: parseDouble(json['base_price']),
      costPrice: parseDouble(json['cost_price']),
      tax: parseDouble(json['tax']),
      isDisplayed: json['is_displayed'] == 1 || json['is_displayed'] == true,
      hasVariants: json['has_variants'] == 1 || json['has_variants'] == true,
      isWished: parseBool(json['is_wished']),
      inCart: json['in_cart'] == true || json['in_cart'] == 1,
      keyDefaultImage: json['key_default_image']?.toString(),
      totalSales: json['total_sales']?.toString(),
      media:
          (json['media'] as List?)
              ?.map((item) => ProductMediaModel.fromJson(item))
              .toList() ??
          [],
      variants:
          (json['variants'] as List?)
              ?.map((item) => ProductVariantModel.fromJson(item))
              .toList() ??
          [],
      reviews:
          (json['reviews'] as List?)
              ?.map((item) => ProductReviewsModel.fromJson(item))
              .toList() ??
          [],
      category:
          json['category'] != null
              ? ProductItemCategoryModel.fromJson(json['category'])
              : null,
      isFreeShipping:
          json['is_free_shipping'] != null
              ? parseInt(json['is_free_shipping'])
              : null,
      totalDiscountsValue: totalDiscount,
      totalRating:
          json['total_rating'] != null
              ? double.tryParse(json['total_rating'].toString())
              : null,
    );
  }

  double get discountedPrice {
    final safeDiscount = totalDiscountsValue.isNaN ? 0.0 : totalDiscountsValue;
    final v = basePrice - safeDiscount;
    return v < 0 ? 0 : v;
  }

  bool get hasDiscount =>
      !totalDiscountsValue.isNaN && totalDiscountsValue > 0.0;

  bool get hasFreeShipping => (isFreeShipping ?? 0) != 0;
}
