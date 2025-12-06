class PageLinkModel {
  final String? url;
  final String label;
  final bool active;

  PageLinkModel({this.url, required this.label, required this.active});

  factory PageLinkModel.fromJson(Map<String, dynamic> json) {
    return PageLinkModel(
      url: json['url'] as String?,
      label: json['label'] as String,
      active: json['active'] as bool,
    );
  }
}
