class StoreItemMediaModel {
  final int id;
  final String name;
  final String url;

  StoreItemMediaModel({
    required this.id,
    required this.name,
    required this.url,
  });

  factory StoreItemMediaModel.fromJson(Map<String, dynamic> json) {
    return StoreItemMediaModel(
      id: json['id'] as int,
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }
}
