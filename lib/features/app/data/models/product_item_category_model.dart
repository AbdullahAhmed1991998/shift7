class ProductItemCategoryModel {
  final int id;
  final int parentId;
  final int storeId;
  final String nameAr;
  final String nameEn;
  final String slug;
  final int isMarket;
  final String createdAt;
  final String updatedAt;
  final List<dynamic> discounts;

  ProductItemCategoryModel({
    required this.id,
    required this.parentId,
    required this.storeId,
    required this.nameAr,
    required this.nameEn,
    required this.slug,
    required this.isMarket,
    required this.createdAt,
    required this.updatedAt,
    required this.discounts,
  });

  factory ProductItemCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductItemCategoryModel(
      id: json['id'],
      parentId: json['parent_id'] ?? 0,
      storeId: json['store_id'] ?? 0,
      nameAr: json['name_ar'] ?? '',
      nameEn: json['name_en'] ?? '',
      slug: json['slug'] ?? '',
      isMarket: json['is_market'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      discounts: json['discounts'] ?? [],
    );
  }
}
