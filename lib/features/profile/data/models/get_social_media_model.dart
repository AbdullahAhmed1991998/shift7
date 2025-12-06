class GetSocialMediaModel {
  final bool isSuccess;
  final String message;
  final List<SocialItem> data;
  final dynamic errors;

  GetSocialMediaModel({
    required this.isSuccess,
    required this.message,
    required this.data,
    this.errors,
  });

  factory GetSocialMediaModel.fromJson(Map<String, dynamic>? json) {
    final m = json ?? const <String, dynamic>{};
    return GetSocialMediaModel(
      isSuccess: m['is_success'] == true,
      message: (m['message'] ?? '') as String,
      data:
          (m['data'] as List? ?? [])
              .map((e) => SocialItem.fromJson(e as Map<String, dynamic>?))
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

class SocialItem {
  final String name;
  final String url;
  final int status;

  SocialItem({required this.name, required this.url, required this.status});

  factory SocialItem.fromJson(Map<String, dynamic>? json) {
    final m = json ?? const <String, dynamic>{};
    return SocialItem(
      name: (m['name'] ?? '') as String,
      url: (m['url'] ?? '') as String,
      status: (m['status'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'url': url, 'status': status};
}
