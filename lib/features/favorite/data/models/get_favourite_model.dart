import 'dart:convert';

class WishlistResponseModel {
  final bool isSuccess;
  final String message;
  final PaginationData data;
  final Map<String, dynamic>? errors;

  const WishlistResponseModel({
    required this.isSuccess,
    required this.message,
    required this.data,
    this.errors,
  });

  factory WishlistResponseModel.fromJson(Map<String, dynamic> json) {
    return WishlistResponseModel(
      isSuccess: _asBool(json['is_success']),
      message: _asString(json['message']),
      data:
          json['data'] != null
              ? PaginationData.fromJson(json['data'])
              : const PaginationData(),
      errors: _asMap(json['errors']),
    );
  }

  factory WishlistResponseModel.fromJsonString(String source) {
    final decoded = jsonDecode(source);
    if (decoded is Map<String, dynamic>) {
      return WishlistResponseModel.fromJson(decoded);
    }
    return const WishlistResponseModel(
      isSuccess: false,
      message: '',
      data: PaginationData(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_success': isSuccess,
      'message': message,
      'data': data.toJson(),
      'errors': errors,
    };
  }

  WishlistResponseModel copyWith({
    bool? isSuccess,
    String? message,
    PaginationData? data,
    Map<String, dynamic>? errors,
  }) {
    return WishlistResponseModel(
      isSuccess: isSuccess ?? this.isSuccess,
      message: message ?? this.message,
      data: data ?? this.data,
      errors: errors ?? this.errors,
    );
  }
}

class PaginationData {
  final int currentPage;
  final List<WishlistItemModel> data;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<LinkModel> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  const PaginationData({
    this.currentPage = 1,
    this.data = const <WishlistItemModel>[],
    this.firstPageUrl = '',
    this.from = 0,
    this.lastPage = 1,
    this.lastPageUrl = '',
    this.links = const <LinkModel>[],
    this.nextPageUrl,
    this.path = '',
    this.perPage = 10,
    this.prevPageUrl,
    this.to = 0,
    this.total = 0,
  });

  factory PaginationData.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final rawLinks = json['links'];

    return PaginationData(
      currentPage: _asInt(json['current_page']),
      data:
          rawData is List
              ? rawData.map((e) {
                if (e is Map<String, dynamic>) {
                  return WishlistItemModel.fromJson(e);
                }
                return const WishlistItemModel();
              }).toList()
              : const <WishlistItemModel>[],
      firstPageUrl: _asString(json['first_page_url']),
      from: _asInt(json['from']),
      lastPage: _asInt(json['last_page']),
      lastPageUrl: _asString(json['last_page_url']),
      links:
          rawLinks is List
              ? rawLinks.map((e) {
                if (e is Map<String, dynamic>) {
                  return LinkModel.fromJson(e);
                }
                return const LinkModel();
              }).toList()
              : const <LinkModel>[],
      nextPageUrl: json['next_page_url'] as String?,
      path: _asString(json['path']),
      perPage: _asInt(json['per_page']),
      prevPageUrl: json['prev_page_url'] as String?,
      to: _asInt(json['to']),
      total: _asInt(json['total']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': data.map((e) => e.toJson()).toList(),
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

  PaginationData copyWith({
    int? currentPage,
    List<WishlistItemModel>? data,
    String? firstPageUrl,
    int? from,
    int? lastPage,
    String? lastPageUrl,
    List<LinkModel>? links,
    String? nextPageUrl,
    String? path,
    int? perPage,
    String? prevPageUrl,
    int? to,
    int? total,
  }) {
    return PaginationData(
      currentPage: currentPage ?? this.currentPage,
      data: data ?? this.data,
      firstPageUrl: firstPageUrl ?? this.firstPageUrl,
      from: from ?? this.from,
      lastPage: lastPage ?? this.lastPage,
      lastPageUrl: lastPageUrl ?? this.lastPageUrl,
      links: links ?? this.links,
      nextPageUrl: nextPageUrl ?? this.nextPageUrl,
      path: path ?? this.path,
      perPage: perPage ?? this.perPage,
      prevPageUrl: prevPageUrl ?? this.prevPageUrl,
      to: to ?? this.to,
      total: total ?? this.total,
    );
  }
}

class LinkModel {
  final String? url;
  final String label;
  final bool active;

  const LinkModel({this.url, this.label = '', this.active = false});

  factory LinkModel.fromJson(Map<String, dynamic> json) {
    return LinkModel(
      url: json['url'] as String?,
      label: _asString(json['label']),
      active: _asBool(json['active']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'label': label, 'active': active};
  }

  LinkModel copyWith({String? url, String? label, bool? active}) {
    return LinkModel(
      url: url ?? this.url,
      label: label ?? this.label,
      active: active ?? this.active,
    );
  }
}

class WishlistItemModel {
  final int id;
  final String nameAr;
  final String nameEn;
  final String subNameAr;
  final String subNameEn;
  final String? code;
  final String slug;
  final bool isDisplayed;
  final double basePrice;
  final List<MediaModel> media;

  const WishlistItemModel({
    this.id = 0,
    this.nameAr = '',
    this.nameEn = '',
    this.subNameAr = '',
    this.subNameEn = '',
    this.code,
    this.slug = '',
    this.isDisplayed = false,
    this.basePrice = 0.0,
    this.media = const <MediaModel>[],
  });

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    final rawMedia = json['media'];
    return WishlistItemModel(
      id: _asInt(json['id']),
      nameAr: _asString(json['name_ar']).trim(),
      nameEn: _asString(json['name_en']).trim(),
      subNameAr: _asString(json['sub_name_ar']).trim(),
      subNameEn: _asString(json['sub_name_en']).trim(),
      code: json['code'] as String?,
      slug: _asString(json['slug']),
      isDisplayed: _asBool(json['is_displayed']),
      basePrice: _asDouble(json['base_price']),
      media:
          rawMedia is List
              ? rawMedia.map((e) {
                if (e is Map<String, dynamic>) {
                  return MediaModel.fromJson(e);
                }
                return const MediaModel();
              }).toList()
              : const <MediaModel>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_ar': nameAr,
      'name_en': nameEn,
      'sub_name_ar': subNameAr,
      'sub_name_en': subNameEn,
      'code': code,
      'slug': slug,
      'is_displayed': isDisplayed ? 1 : 0,
      'base_price': basePrice.toString(),
      'media': media.map((e) => e.toJson()).toList(),
    };
  }

  WishlistItemModel copyWith({
    int? id,
    String? nameAr,
    String? nameEn,
    String? subNameAr,
    String? subNameEn,
    String? code,
    String? slug,
    bool? isDisplayed,
    double? basePrice,
    List<MediaModel>? media,
  }) {
    return WishlistItemModel(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      subNameAr: subNameAr ?? this.subNameAr,
      subNameEn: subNameEn ?? this.subNameEn,
      code: code ?? this.code,
      slug: slug ?? this.slug,
      isDisplayed: isDisplayed ?? this.isDisplayed,
      basePrice: basePrice ?? this.basePrice,
      media: media ?? this.media,
    );
  }

  String get displayNameArFirst => nameAr.isNotEmpty ? nameAr : nameEn;
  String get displayNameEnFirst => nameEn.isNotEmpty ? nameEn : nameAr;
  String get thumbnailUrl => media.isNotEmpty ? media.first.url : '';
}

class MediaModel {
  final int id;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String url;

  const MediaModel({
    this.id = 0,
    this.name = '',
    this.createdAt,
    this.updatedAt,
    this.url = '',
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      id: _asInt(json['id']),
      name: _asString(json['name']),
      createdAt: _asDateTime(json['created_at']),
      updatedAt: _asDateTime(json['updated_at']),
      url: _asString(json['url']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'url': url,
    };
  }

  MediaModel copyWith({
    int? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? url,
  }) {
    return MediaModel(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      url: url ?? this.url,
    );
  }
}

// Helper functions
int _asInt(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  if (v is double) return v.floor();
  if (v is String) {
    final s = v.trim();
    final n = int.tryParse(s);
    if (n != null) return n;
    final d = double.tryParse(s);
    if (d != null) return d.floor();
  }
  return 0;
}

double _asDouble(dynamic v) {
  if (v == null) return 0.0;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  if (v is String) {
    final s = v.trim();
    final n = double.tryParse(s);
    if (n != null) return n;
    final normalized = s.replaceAll(',', '');
    final n2 = double.tryParse(normalized);
    if (n2 != null) return n2;
  }
  return 0.0;
}

String _asString(dynamic v) {
  if (v == null) return '';
  if (v is String) return v;
  return v.toString();
}

bool _asBool(dynamic v) {
  if (v is bool) return v;
  if (v is int) return v == 1;
  if (v is double) return v == 1.0;
  if (v is String) {
    final s = v.trim().toLowerCase();
    return s == '1' || s == 'true' || s == 'yes' || s == 'y';
  }
  return false;
}

Map<String, dynamic>? _asMap(dynamic v) {
  if (v == null) return null;
  if (v is Map<String, dynamic>) return v;
  if (v is Map) {
    return v.map((key, value) => MapEntry(key.toString(), value));
  }
  return null;
}

DateTime? _asDateTime(dynamic v) {
  if (v == null) return null;
  if (v is DateTime) return v;
  if (v is int) {
    if (v > 9999999999) {
      return DateTime.fromMillisecondsSinceEpoch(v, isUtc: true);
    }
    return DateTime.fromMillisecondsSinceEpoch(v * 1000, isUtc: true);
  }
  if (v is String) {
    final parsed = DateTime.tryParse(v);
    if (parsed != null) return parsed.isUtc ? parsed : parsed.toUtc();
  }
  return null;
}
