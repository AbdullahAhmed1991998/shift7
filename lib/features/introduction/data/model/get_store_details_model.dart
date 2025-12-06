class GetStoreDetailsModel {
  final bool isSuccess;
  final String message;
  final StoreItemData store;
  final StoreListData stores;
  final dynamic errors;

  GetStoreDetailsModel({
    required this.isSuccess,
    required this.message,
    required this.store,
    required this.stores,
    this.errors,
  });

  factory GetStoreDetailsModel.fromJson(Map<String, dynamic> json) {
    return GetStoreDetailsModel(
      isSuccess: json['is_success'] as bool,
      message: json['message'] as String,
      store: StoreItemData.fromJson(json['data']['store']),
      stores: StoreListData.fromJson(json['data']['stores']),
      errors: json['errors'],
    );
  }
}

class StoreListData {
  final int currentPage;
  final List<StoreItemData> data;

  StoreListData({required this.currentPage, required this.data});

  factory StoreListData.fromJson(Map<String, dynamic> json) {
    return StoreListData(
      currentPage: json['current_page'] as int,
      data:
          (json['data'] as List).map((e) => StoreItemData.fromJson(e)).toList(),
    );
  }
}

class StoreItemData {
  final int id;
  final String nameAr;
  final String nameEn;
  final int isDefault;
  final int hasMarket;
  final List<StoreItemMediaModel> media;
  final List<StoreMarketModel> markets;

  StoreItemData({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.isDefault,
    required this.hasMarket,
    required this.media,
    required this.markets,
  });

  factory StoreItemData.fromJson(Map<String, dynamic> json) {
    return StoreItemData(
      id: json['id'] as int,
      nameAr: json['name_ar'] as String,
      nameEn: json['name_en'] as String,
      isDefault: json['is_default'] as int,
      hasMarket: json['has_market'] as int,
      media:
          (json['media'] as List)
              .map((e) => StoreItemMediaModel.fromJson(e))
              .toList(),
      markets:
          (json['markets'] != null)
              ? (json['markets'] as List)
                  .map((e) => StoreMarketModel.fromJson(e))
                  .toList()
              : [],
    );
  }
}

class StoreItemMediaModel {
  final int id;
  final String name;
  final String url;
  final DateTime createdAt;
  final DateTime updatedAt;
  final MediaLinks mediaLinks;

  const StoreItemMediaModel({
    required this.id,
    required this.name,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
    required this.mediaLinks,
  });

  factory StoreItemMediaModel.fromJson(Map<String, dynamic> json) {
    return StoreItemMediaModel(
      id: _asInt(json['id']),
      name: _asString(json['name']),
      url: _asString(json['url']),
      createdAt: _asDate(json['created_at']),
      updatedAt: _asDate(json['updated_at']),
      mediaLinks: MediaLinks.fromJson(_asMap(json['media_links'])),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'media_links': mediaLinks.toJson(),
    };
  }
}

class MediaLinks {
  final int id;
  final int mediaId;
  final int type;

  const MediaLinks({
    required this.id,
    required this.mediaId,
    required this.type,
  });

  factory MediaLinks.fromJson(Map<String, dynamic> json) {
    return MediaLinks(
      id: _asInt(json['id']),
      mediaId: _asInt(json['media_id']),
      type: _asInt(json['type']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'media_id': mediaId, 'type': type};
  }
}

int _asInt(dynamic v, [int def = 0]) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v.trim()) ?? def;
  return def;
}

String _asString(dynamic v, [String def = '']) {
  if (v == null) return def;
  final s = v.toString();
  return s.isEmpty ? def : s;
}

DateTime _asDate(dynamic v) {
  if (v is DateTime) return v;
  if (v is int) {
    try {
      return DateTime.fromMillisecondsSinceEpoch(v);
    } catch (_) {}
  }
  if (v is String) {
    final s = v.trim();
    if (s.isNotEmpty) {
      try {
        return DateTime.parse(s);
      } catch (_) {}
    }
  }
  return DateTime.fromMillisecondsSinceEpoch(0);
}

Map<String, dynamic> _asMap(dynamic v) {
  if (v is Map) {
    return v.map((k, val) => MapEntry(k.toString(), val));
  }
  return const <String, dynamic>{};
}

class StoreMarketModel {
  final int id;
  final int? parentId;
  final int storeId;
  final String nameAr;
  final String nameEn;
  final String slug;
  final int isMarket;
  final List<StoreMarketMediaModel> media;

  StoreMarketModel({
    required this.id,
    required this.parentId,
    required this.storeId,
    required this.nameAr,
    required this.nameEn,
    required this.slug,
    required this.isMarket,
    required this.media,
  });

  factory StoreMarketModel.fromJson(Map<String, dynamic> json) {
    return StoreMarketModel(
      id: json['id'] as int,
      parentId: json['parent_id'] as int?,
      storeId: json['store_id'] as int,
      nameAr: json['name_ar'] as String,
      nameEn: json['name_en'] as String,
      slug: json['slug'] as String,
      isMarket: json['is_market'] as int,
      media:
          (json['media'] as List)
              .map((item) => StoreMarketMediaModel.fromJson(item))
              .toList(),
    );
  }
}

class StoreMarketMediaModel {
  final int id;
  final String name;
  final String url;
  final MediaLinks mediaLinks;

  StoreMarketMediaModel({
    required this.id,
    required this.name,
    required this.url,
    required this.mediaLinks,
  });

  factory StoreMarketMediaModel.fromJson(Map<String, dynamic> json) {
    return StoreMarketMediaModel(
      id: json['id'] as int,
      name: json['name'] as String,
      url: json['url'] as String,
      mediaLinks:
          json['media_links'] != null
              ? MediaLinks.fromJson(_asMap(json['media_links']))
              : MediaLinks(id: 0, mediaId: 0, type: 0),
    );
  }
}
