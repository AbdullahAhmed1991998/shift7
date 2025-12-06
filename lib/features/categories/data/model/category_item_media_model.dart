class CategoryItemMediaModel {
  final int id;
  final String name;
  final String url;

  CategoryItemMediaModel({
    required this.id,
    required this.name,
    required this.url,
  });

  factory CategoryItemMediaModel.fromJson(Map<String, dynamic> json) {
    return CategoryItemMediaModel(
      id: json['id'] as int,
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }
}
