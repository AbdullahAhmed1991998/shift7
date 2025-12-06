import 'package:shift7_app/features/app/data/models/product_item_model.dart';
import 'package:shift7_app/features/app/data/models/search_brand_model.dart';
import 'package:shift7_app/features/categories/data/model/category_item_model.dart';

class CustomTabsDetailsModel {
  final bool isSuccess;
  final String message;
  final int type;
  final List<dynamic> data;

  CustomTabsDetailsModel({
    required this.isSuccess,
    required this.message,
    required this.type,
    required this.data,
  });

  factory CustomTabsDetailsModel.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'];
    final type = dataJson['type'];
    final rawData = dataJson['details']['data'] as List;
    List<dynamic> parsedData;

    if (type == 1) {
      parsedData = rawData.map((e) => CategoryItemModel.fromJson(e)).toList();
    } else if (type == 2) {
      parsedData = rawData.map((e) => ProductItemModel.fromJson(e)).toList();
    } else if (type == 3) {
      parsedData = rawData.map((e) => SearchBrandModel.fromJson(e)).toList();
    } else {
      parsedData = [];
    }

    return CustomTabsDetailsModel(
      isSuccess: json['is_success'] ?? false,
      message: json['message'] ?? '',
      type: type,
      data: parsedData,
    );
  }
}
