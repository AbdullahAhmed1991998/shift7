import 'dart:convert';

import 'package:shift7_app/core/functions/parsing_utils.dart';
import 'package:shift7_app/features/cart/data/models/address_model.dart';

class GetAddressListModel {
  final bool isSuccess;
  final String message;
  final List<AddressModel> data;
  final Map<String, dynamic>? errors;

  const GetAddressListModel({
    required this.isSuccess,
    required this.message,
    required this.data,
    this.errors,
  });

  factory GetAddressListModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final list =
        (rawData is List)
            ? rawData
                .whereType<Map>()
                .map((e) => AddressModel.fromJson(Map<String, dynamic>.from(e)))
                .toList(growable: false)
            : const <AddressModel>[];

    return GetAddressListModel(
      isSuccess: asBool(json['is_success']),
      message: asStringOrEmpty(json['message']),
      data: List<AddressModel>.unmodifiable(list),
      errors: asMapStringDynamicOrNull(json['errors']),
    );
  }

  factory GetAddressListModel.fromJsonString(String source) =>
      GetAddressListModel.fromJson(jsonDecode(source) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => {
    'is_success': isSuccess,
    'message': message,
    'data': data.map((e) => e.toJson()).toList(growable: false),
    'errors': errors,
  };

  GetAddressListModel copyWith({
    bool? isSuccess,
    String? message,
    List<AddressModel>? data,
    Map<String, dynamic>? errors,
  }) {
    return GetAddressListModel(
      isSuccess: isSuccess ?? this.isSuccess,
      message: message ?? this.message,
      data: data != null ? List<AddressModel>.unmodifiable(data) : this.data,
      errors: errors ?? this.errors,
    );
  }
}
