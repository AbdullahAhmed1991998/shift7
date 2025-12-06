import 'package:shift7_app/features/app/data/models/base_response_model.dart';
import 'package:shift7_app/features/app/data/models/product_item_model.dart';

class NewArrivalsModel extends BaseResponseModel {
  final List<ProductItemModel> products;

  NewArrivalsModel({
    required super.isSuccess,
    required super.message,
    required this.products,
  });

  factory NewArrivalsModel.fromJson(Map<String, dynamic> json) {
    return NewArrivalsModel(
      isSuccess: json['is_success'],
      message: json['message'],
      products:
          (json['data']['data'] as List)
              .map((p) => ProductItemModel.fromJson(p))
              .toList(),
    );
  }
}
