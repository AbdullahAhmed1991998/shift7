class PrivacyAndPolicyModel {
  final bool? isSuccess;
  final String? message;
  final List<PrivacyPolicyData>? data;
  final dynamic errors;

  PrivacyAndPolicyModel({this.isSuccess, this.message, this.data, this.errors});

  factory PrivacyAndPolicyModel.fromJson(Map<String, dynamic> json) {
    return PrivacyAndPolicyModel(
      isSuccess: json['is_success'] as bool?,
      message: json['message'] as String?,
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => PrivacyPolicyData.fromJson(item))
              .toList(),
      errors: json['errors'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "is_success": isSuccess,
      "message": message,
      "data": data?.map((e) => e.toJson()).toList(),
      "errors": errors,
    };
  }
}

class PrivacyPolicyData {
  final int? id;
  final String? key;
  final String? value;
  final String? createdAt;
  final String? updatedAt;

  PrivacyPolicyData({
    this.id,
    this.key,
    this.value,
    this.createdAt,
    this.updatedAt,
  });

  factory PrivacyPolicyData.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyData(
      id: json['id'] as int?,
      key: json['key'] as String?,
      value: json['value'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "key": key,
      "value": value,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }
}
