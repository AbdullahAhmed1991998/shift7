class SearchMediaModel {
  final int id;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String url;

  SearchMediaModel({
    required this.id,
    required this.name,
    this.createdAt,
    this.updatedAt,
    required this.url,
  });

  factory SearchMediaModel.fromJson(Map<String, dynamic> json) {
    return SearchMediaModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      createdAt:
          json['created_at'] != null
              ? DateTime.tryParse(json['created_at'])
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.tryParse(json['updated_at'])
              : null,
      url: json['url'] ?? '',
    );
  }
}
