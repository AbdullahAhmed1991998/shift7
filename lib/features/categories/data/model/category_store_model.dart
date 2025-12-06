class CategoryStoreModel {
  final int id;
  final String nameAr;
  final String nameEn;
  final int isDefault;
  final int hasMarket;

  CategoryStoreModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.isDefault,
    required this.hasMarket,
  });

  factory CategoryStoreModel.fromJson(Map<String, dynamic> json) {
    return CategoryStoreModel(
      id: json['id'] as int,
      nameAr: json['name_ar'] as String,
      nameEn: json['name_en'] as String,
      isDefault: json['is_default'] as int,
      hasMarket: json['has_market'] as int,
    );
  }
}
