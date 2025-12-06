class GetUserAddressModel {
  final bool isSuccess;
  final String message;
  final List<AddressModel> data;
  final dynamic errors;

  GetUserAddressModel({
    required this.isSuccess,
    required this.message,
    required this.data,
    this.errors,
  });

  factory GetUserAddressModel.fromJson(Map<String, dynamic>? json) {
    final m = json ?? const <String, dynamic>{};
    return GetUserAddressModel(
      isSuccess: m['is_success'] == true,
      message: (m['message'] ?? '') as String,
      data:
          (m['data'] as List? ?? [])
              .map((e) => AddressModel.fromJson(e as Map<String, dynamic>?))
              .toList(),
      errors: m['errors'],
    );
  }

  Map<String, dynamic> toJson() => {
    'is_success': isSuccess,
    'message': message,
    'data': data.map((e) => e.toJson()).toList(),
    'errors': errors,
  };
}

class AddressModel {
  final int id;
  final int userId;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String country;
  final String zipCode;
  final int isDefault;
  final String long;
  final String lat;
  final String createdAt;
  final String updatedAt;

  AddressModel({
    required this.id,
    required this.userId,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.country,
    required this.zipCode,
    required this.isDefault,
    required this.long,
    required this.lat,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic>? json) {
    final m = json ?? const <String, dynamic>{};
    return AddressModel(
      id: (m['id'] ?? 0) as int,
      userId: (m['user_id'] ?? 0) as int,
      addressLine1: (m['address_line_1'] ?? '') as String,
      addressLine2: (m['address_line_2'] ?? '') as String,
      city: (m['city'] ?? '') as String,
      country: (m['country'] ?? '') as String,
      zipCode: (m['zip_code'] ?? '') as String,
      isDefault: (m['is_default'] ?? 0) as int,
      long: (m['long'] ?? '') as String,
      lat: (m['lat'] ?? '') as String,
      createdAt: (m['created_at'] ?? '') as String,
      updatedAt: (m['updated_at'] ?? '') as String,
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
    'is_default': isDefault,
    'long': long,
    'lat': lat,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}
