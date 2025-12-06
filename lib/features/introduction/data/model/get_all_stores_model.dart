import 'package:shift7_app/features/introduction/data/model/store_item_data_model.dart';

class GetAllStoresModel {
  final bool isSuccess;
  final String message;
  final List<StoreItemDataModel> data;
  final dynamic errors;

  GetAllStoresModel({
    required this.isSuccess,
    required this.message,
    required this.data,
    this.errors,
  });

  factory GetAllStoresModel.fromJson(Map<String, dynamic> json) {
    final payload = json['data'] as Map<String, dynamic>;
    final items = payload['data'] as List<dynamic>?;
    return GetAllStoresModel(
      isSuccess: json['is_success'] as bool,
      message: json['message'] as String,
      data:
          items != null
              ? items
                  .map(
                    (e) =>
                        StoreItemDataModel.fromJson(e as Map<String, dynamic>),
                  )
                  .toList()
              : <StoreItemDataModel>[],
      errors: json['errors'],
    );
  }
}
