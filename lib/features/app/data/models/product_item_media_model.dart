class ProductMediaModel {
  final int id;
  final String name;
  final String url;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductMediaModel({
    required this.id,
    required this.name,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductMediaModel.fromJson(Map<String, dynamic> json) {
    return ProductMediaModel(
      id: json['id'],
      name: json['name'] ?? '',
      url: json['url']?.replaceAll('\n', '').replaceAll(' ', '') ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }
}
