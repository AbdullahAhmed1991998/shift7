import 'package:shift7_app/features/app/data/models/search_media_model.dart';

class SearchCategoryModel {
  final int id;
  final int? parentId;
  final int storeId;
  final String nameAr;
  final String nameEn;
  final String slug;
  final bool isMarket;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool hasSubcategories;
  final List<SearchMediaModel> media;

  SearchCategoryModel({
    required this.id,
    this.parentId,
    required this.storeId,
    required this.nameAr,
    required this.nameEn,
    required this.slug,
    required this.isMarket,
    this.createdAt,
    this.updatedAt,
    required this.hasSubcategories,
    required this.media,
  });

  factory SearchCategoryModel.fromJson(Map<String, dynamic> json) {
    return SearchCategoryModel(
      id: json['id'] ?? 0,
      parentId: json['parent_id'],
      storeId: json['store_id'] ?? 0,
      nameAr: json['name_ar'] ?? '',
      nameEn: json['name_en'] ?? '',
      slug: json['slug'] ?? '',
      isMarket: (json['is_market'] ?? 0) == 1,
      createdAt:
          json['created_at'] != null
              ? DateTime.tryParse(json['created_at'])
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.tryParse(json['updated_at'])
              : null,
      hasSubcategories: json['has_subcategories'] ?? false,
      media:
          json['media'] != null
              ? (json['media'] as List)
                  .map((mediaJson) => SearchMediaModel.fromJson(mediaJson))
                  .toList()
              : [],
    );
  }
}
