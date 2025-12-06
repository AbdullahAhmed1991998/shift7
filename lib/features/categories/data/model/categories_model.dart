import 'package:shift7_app/features/categories/data/model/category_item_model.dart';

class CategoriesModel {
  final bool isSuccess;
  final String message;
  final List<CategoryItemModel> data;
  final dynamic errors;

  CategoriesModel({
    required this.isSuccess,
    required this.message,
    required this.data,
    this.errors,
  });

  factory CategoriesModel.fromJson(Map<String, dynamic> json) {
    return CategoriesModel(
      isSuccess: json['is_success'] == true,
      message: (json['message'] ?? '') as String,
      data:
          (json['data'] as List)
              .map((e) => CategoryItemModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      errors: json['errors'],
    );
  }
}
