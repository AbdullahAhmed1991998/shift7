import 'cart_details_data_model.dart';

class CartDetailsResponseModel {
  final bool isSuccess;
  final String message;
  final CartDetailsDataModel data;

  CartDetailsResponseModel({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory CartDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    if (rawData is Map<String, dynamic>) {
      return CartDetailsResponseModel(
        isSuccess: json['is_success'] ?? false,
        message: json['message'] ?? '',
        data: CartDetailsDataModel.fromJson(rawData),
      );
    }
    return CartDetailsResponseModel(
      isSuccess: json['is_success'] ?? false,
      message: json['message'] ?? '',
      data: CartDetailsDataModel(stores: []),
    );
  }
}
