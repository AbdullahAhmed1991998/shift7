import 'dart:convert';

GetNotificationsModel notificationsResponseFromJson(String source) =>
    GetNotificationsModel.fromJson(json.decode(source) as Map<String, dynamic>);

String notificationsResponseToJson(GetNotificationsModel data) =>
    json.encode(data.toJson());

class GetNotificationsModel {
  final bool isSuccess;
  final String message;
  final NotificationsPageData data;
  final dynamic errors;

  GetNotificationsModel({
    required this.isSuccess,
    required this.message,
    required this.data,
    this.errors,
  });

  factory GetNotificationsModel.fromJson(Map<String, dynamic> json) {
    return GetNotificationsModel(
      isSuccess: _parseBool(json['is_success']),
      message: _parseString(json['message']),
      data: NotificationsPageData.fromJson(
        (json['data'] as Map<String, dynamic>?) ?? const {},
      ),
      errors: json['errors'],
    );
  }

  Map<String, dynamic> toJson() => {
    'is_success': isSuccess,
    'message': message,
    'data': data.toJson(),
    'errors': errors,
  };
}

class NotificationsPageData {
  final int currentPage;
  final List<NotificationItem> items;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<PageLink> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  NotificationsPageData({
    required this.currentPage,
    required this.items,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory NotificationsPageData.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List?) ?? const [];
    final linksList = (json['links'] as List?) ?? const [];

    return NotificationsPageData(
      currentPage: _parseInt(json['current_page']),
      items:
          list
              .map(
                (e) => NotificationItem.fromJson(
                  (e as Map?)?.cast<String, dynamic>() ?? const {},
                ),
              )
              .toList(),
      firstPageUrl: _parseString(json['first_page_url']),
      from: _parseInt(json['from']),
      lastPage: _parseInt(json['last_page']),
      lastPageUrl: _parseString(json['last_page_url']),
      links:
          linksList
              .map(
                (e) => PageLink.fromJson(
                  (e as Map?)?.cast<String, dynamic>() ?? const {},
                ),
              )
              .toList(),
      nextPageUrl: _parseNullableString(json['next_page_url']),
      path: _parseString(json['path']),
      perPage: _parseInt(json['per_page']),
      prevPageUrl: _parseNullableString(json['prev_page_url']),
      to: _parseInt(json['to']),
      total: _parseInt(json['total']),
    );
  }

  Map<String, dynamic> toJson() => {
    'current_page': currentPage,
    'data': items.map((e) => e.toJson()).toList(),
    'first_page_url': firstPageUrl,
    'from': from,
    'last_page': lastPage,
    'last_page_url': lastPageUrl,
    'links': links.map((e) => e.toJson()).toList(),
    'next_page_url': nextPageUrl,
    'path': path,
    'per_page': perPage,
    'prev_page_url': prevPageUrl,
    'to': to,
    'total': total,
  };
}

class NotificationItem {
  final int id;
  final String title;
  final String body;
  final bool isSeen;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.isSeen,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: _parseInt(json['id']),
      title: _parseString(json['title']),
      body: _parseString(json['body']),
      isSeen: _parseBool(json['is_seen']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'is_seen': isSeen ? 1 : 0,
  };
}

class PageLink {
  final String? url;
  final String label;
  final bool active;

  PageLink({required this.url, required this.label, required this.active});

  factory PageLink.fromJson(Map<String, dynamic> json) {
    return PageLink(
      url: _parseNullableString(json['url']),
      label: _parseString(json['label']),
      active: _parseBool(json['active']),
    );
  }

  Map<String, dynamic> toJson() => {
    'url': url,
    'label': label,
    'active': active,
  };
}

bool _parseBool(dynamic v) {
  if (v is bool) return v;
  if (v is num) return v != 0;
  if (v is String) {
    final s = v.toLowerCase();
    return s == 'true' || s == '1' || s == 'yes';
  }
  return false;
}

int _parseInt(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) {
    final s = v.trim();
    if (s.isEmpty) return 0;
    return int.tryParse(s) ?? 0;
  }
  return 0;
}

String _parseString(dynamic v) {
  if (v == null) return '';
  return v.toString();
}

String? _parseNullableString(dynamic v) {
  if (v == null) return null;
  final s = v.toString();
  return s.isEmpty ? null : s;
}
