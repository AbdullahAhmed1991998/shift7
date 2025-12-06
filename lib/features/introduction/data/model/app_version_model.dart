class AppVersionResponseModel {
  final bool isSuccess;
  final String message;
  final AppVersionDataModel? data;
  final dynamic errors;

  const AppVersionResponseModel({
    required this.isSuccess,
    required this.message,
    this.data,
    this.errors,
  });

  factory AppVersionResponseModel.fromJson(Map<String, dynamic> json) {
    return AppVersionResponseModel(
      isSuccess: json['is_success'] == true,
      message: json['message']?.toString() ?? '',
      data:
          json['data'] != null
              ? AppVersionDataModel.fromJson(
                json['data'] as Map<String, dynamic>,
              )
              : null,
      errors: json['errors'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_success': isSuccess,
      'message': message,
      'data': data?.toJson(),
      'errors': errors,
    };
  }
}

class AppVersionDataModel {
  final int id;
  final String latestVersion;
  final String minSupportedVersion;
  final String storeUrlAndroid;
  final String storeUrlIos;

  const AppVersionDataModel({
    required this.id,
    required this.latestVersion,
    required this.minSupportedVersion,
    required this.storeUrlAndroid,
    required this.storeUrlIos,
  });

  factory AppVersionDataModel.fromJson(Map<String, dynamic> json) {
    return AppVersionDataModel(
      id: (json['id'] as num).toInt(),
      latestVersion: json['latest_version']?.toString() ?? '',
      minSupportedVersion: json['min_supported_version']?.toString() ?? '',
      storeUrlAndroid: json['store_url_android']?.toString() ?? '',
      storeUrlIos: json['store_url_ios']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latest_version': latestVersion,
      'min_supported_version': minSupportedVersion,
      'store_url_android': storeUrlAndroid,
      'store_url_ios': storeUrlIos,
    };
  }
}
