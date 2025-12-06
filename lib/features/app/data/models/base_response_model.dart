class BaseResponseModel {
  final bool isSuccess;
  final String message;

  BaseResponseModel({required this.isSuccess, required this.message});

  factory BaseResponseModel.fromJson(Map<String, dynamic> json) {
    return BaseResponseModel(
      isSuccess: (json['is_success'] as bool?) ?? false,
      message: (json['message'] as String?) ?? '',
    );
  }
}
