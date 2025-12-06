import 'package:shift7_app/features/app/data/models/product_data_model.dart';

class ProductDetailsResponseModel {
  final bool isSuccess;
  final String message;
  final ProductDataModel data;

  ProductDetailsResponseModel({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ProductDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsResponseModel(
      isSuccess: json['is_success'] ?? false,
      message: json['message'] ?? '',
      data: ProductDataModel.fromJson(json['data'] ?? {}),
    );
  }
}
