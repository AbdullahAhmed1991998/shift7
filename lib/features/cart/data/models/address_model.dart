import 'package:shift7_app/core/functions/parsing_utils.dart';

class AddressModel {
  final int id;
  final int userId;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String country;
  final String? zipCode;
  final double? longitude;
  final double? latitude;
  final bool isDefault;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AddressModel({
    required this.id,
    required this.userId,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.country,
    this.zipCode,
    this.longitude,
    this.latitude,
    required this.isDefault,
    this.createdAt,
    this.updatedAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: asInt(json['id']),
      userId: asInt(json['user_id']),
      addressLine1: asStringOrEmpty(json['address_line_1']),
      addressLine2: asNullableTrimmedString(json['address_line_2']),
      city: asStringOrEmpty(json['city']),
      country: asStringOrEmpty(json['country']),
      zipCode: asNullableTrimmedString(json['zip_code']),
      longitude: asDoubleOrNull(json['long']),
      latitude: asDoubleOrNull(json['lat']),
      isDefault: asBool(json['is_default']),
      createdAt: asDateTimeOrNull(json['created_at']),
      updatedAt: asDateTimeOrNull(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'address_line_1': addressLine1,
    'address_line_2': addressLine2,
    'city': city,
    'country': country,
    'zip_code': zipCode,
    'long': longitude?.toString(),
    'lat': latitude?.toString(),
    'is_default': isDefault ? 1 : 0,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  AddressModel copyWith({
    int? id,
    int? userId,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? country,
    String? zipCode,
    double? longitude,
    double? latitude,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AddressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      country: country ?? this.country,
      zipCode: zipCode ?? this.zipCode,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
