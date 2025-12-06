import 'package:shift7_app/core/functions/parsing_utils.dart';
import 'package:shift7_app/features/cart/data/models/cart_store_summary_model.dart';

class GetCartDetailsModel {
  final bool isSuccess;
  final String message;
  final List<CartStoreSummaryModel> data;
  final Map<String, dynamic>? errors;

  const GetCartDetailsModel({
    required this.isSuccess,
    required this.message,
    required this.data,
    this.errors,
  });

  factory GetCartDetailsModel.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    final list = <CartStoreSummaryModel>[];
    if (raw is List) {
      for (final e in raw) {
        if (e is Map) {
          list.add(
            CartStoreSummaryModel.fromJson(Map<String, dynamic>.from(e)),
          );
        }
      }
    }
    return GetCartDetailsModel(
      isSuccess: asBool(json['is_success']),
      message: asStringOrEmpty(json['message']),
      data: list,
      errors: asMapStringDynamicOrNull(json['errors']),
    );
  }

  Map<String, dynamic> toJson() => {
    'is_success': isSuccess,
    'message': message,
    'data': data.map((e) => e.toJson()).toList(),
    'errors': errors,
  };

  GetCartDetailsModel copyWith({
    bool? isSuccess,
    String? message,
    List<CartStoreSummaryModel>? data,
    Map<String, dynamic>? errors,
  }) {
    return GetCartDetailsModel(
      isSuccess: isSuccess ?? this.isSuccess,
      message: message ?? this.message,
      data: data ?? this.data,
      errors: errors ?? this.errors,
    );
  }
}
