class UserProfileDataModel {
  final bool isSuccess;
  final String message;
  final UserData data;
  final dynamic errors;

  UserProfileDataModel({
    required this.isSuccess,
    required this.message,
    required this.data,
    this.errors,
  });

  factory UserProfileDataModel.fromJson(Map<String, dynamic>? json) {
    final m = json ?? const <String, dynamic>{};
    return UserProfileDataModel(
      isSuccess: (m['is_success'] == true),
      message: (m['message'] as String?) ?? '',
      data: UserData.fromJson((m['data'] as Map<String, dynamic>?) ?? const {}),
      errors: m['errors'],
    );
  }

  Map<String, dynamic> toJson() => {
    'is_success': isSuccess,
    'message': message,
    'data': data.toJson(),
    'errors': errors,
  };
}

class UserData {
  final String name;
  final String email;
  final String phone;
  final DateTime createdAt;
  final String typeDescription;

  UserData({
    required this.name,
    required this.email,
    required this.phone,
    required this.createdAt,
    required this.typeDescription,
  });

  factory UserData.fromJson(Map<String, dynamic>? json) {
    final m = json ?? const <String, dynamic>{};
    final createdAtStr = (m['created_at'] as String?) ?? '';

    return UserData(
      name: (m['name'] as String?) ?? '',
      email: (m['email'] as String?) ?? '',
      phone: (m['phone'] as String?) ?? '',
      createdAt:
          DateTime.tryParse(createdAtStr) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      typeDescription: (m['type_description'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phone': phone.isEmpty ? null : phone,
    'created_at': createdAt.toIso8601String(),
    'type_description': typeDescription.isEmpty ? null : typeDescription,
  };
}
