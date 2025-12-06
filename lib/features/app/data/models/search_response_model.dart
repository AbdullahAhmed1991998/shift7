import 'package:shift7_app/features/app/data/models/search_data_model.dart';

class SearchResponseModel {
  final bool isSuccess;
  final String message;
  final SearchDataModel? data;
  final dynamic errors;

  SearchResponseModel({
    required this.isSuccess,
    required this.message,
    this.data,
    this.errors,
  });

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) {
    return SearchResponseModel(
      isSuccess: json['is_success'] ?? false,
      message: json['message'] ?? '',
      data:
          json['data'] != null ? SearchDataModel.fromJson(json['data']) : null,
      errors: json['errors'],
    );
  }
}
