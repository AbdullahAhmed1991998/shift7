class ProductAttributeModel {
  final int id;
  final String valueAr;
  final String valueEn;
  final bool? isColor;

  ProductAttributeModel({
    required this.id,
    required this.valueAr,
    required this.valueEn,
    this.isColor,
  });

  factory ProductAttributeModel.fromJson(Map<String, dynamic> json) {
    return ProductAttributeModel(
      id: json['id'],
      valueAr: json['value_ar'] ?? '',
      valueEn: json['value_en'] ?? '',
      isColor: json['is_color'],
    );
  }
}
