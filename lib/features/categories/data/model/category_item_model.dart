import 'package:shift7_app/features/categories/data/model/category_item_media_model.dart';

class CategoryItemModel {
  final int id;
  final String nameAr;
  final String nameEn;
  final String slug;
  final int isMarket;
  final int? parentId;
  final int storeId;

  final List<CategoryItemMediaModel> media;
  final CategoryItemModel? parent;

  CategoryItemModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.slug,
    required this.isMarket,
    this.parentId,
    required this.storeId,

    required this.media,
    this.parent,
  });

  factory CategoryItemModel.fromJson(Map<String, dynamic> json) {
    return CategoryItemModel(
      id: json['id'] as int,
      nameAr: json['name_ar'] as String,
      nameEn: json['name_en'] as String,
      slug: json['slug'] as String,
      isMarket: json['is_market'] as int? ?? 0,
      parentId: json['parent_id'] as int?,
      storeId: json['store_id'] as int? ?? 0,

      media:
          (json['media'] as List<dynamic>?)
              ?.map(
                (e) =>
                    CategoryItemMediaModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],

      parent:
          json['parent'] != null
              ? CategoryItemModel.fromJson(
                json['parent'] as Map<String, dynamic>,
              )
              : null,
    );
  }
}
