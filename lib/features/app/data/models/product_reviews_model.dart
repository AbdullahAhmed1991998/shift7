class ProductReviewsModel {
  final int id;
  final int rate;
  final String message;
  final int userId;
  final int modelId;
  final DateTime createdAt;
  final User user;

  ProductReviewsModel({
    required this.id,
    required this.rate,
    required this.message,
    required this.userId,
    required this.modelId,
    required this.createdAt,
    required this.user,
  });

  factory ProductReviewsModel.fromJson(Map<String, dynamic> json) {
    return ProductReviewsModel(
      id: json['id'],
      rate: json['rate'],
      message: json['message'],
      userId: json['user_id'],
      modelId: json['model_id'],
      createdAt: DateTime.parse(json['created_at']),
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rate': rate,
      'message': message,
      'user_id': userId,
      'model_id': modelId,
      'created_at': createdAt.toIso8601String(),
      'user': user.toJson(),
    };
  }
}

class User {
  final int id;
  final String name;
  final String? typeDescription;

  User({required this.id, required this.name, this.typeDescription});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      typeDescription: json['type_description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'type_description': typeDescription};
  }
}
