import 'package:shift7_app/features/app/data/models/base_response_model.dart';
import 'package:shift7_app/features/app/data/models/product_item_model.dart';

class SpecialOfferModel extends BaseResponseModel {
  final List<ProductItemModel> products;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  SpecialOfferModel({
    required super.isSuccess,
    required super.message,
    required this.products,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory SpecialOfferModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;

    final List<dynamic> rawList =
        (data != null && data['data'] is List)
            ? data['data'] as List
            : const [];

    return SpecialOfferModel(
      isSuccess: (json['is_success'] as bool?) ?? false,
      message: (json['message'] as String?) ?? '',
      products:
          rawList
              .map((p) => ProductItemModel.fromJson(p as Map<String, dynamic>))
              .toList(),
      currentPage: (data?['current_page'] as int?) ?? 1,
      lastPage: (data?['last_page'] as int?) ?? 1,
      perPage: (data?['per_page'] as int?) ?? rawList.length,
      total: (data?['total'] as int?) ?? rawList.length,
    );
  }
}
