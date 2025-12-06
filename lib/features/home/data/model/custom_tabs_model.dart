class CustomTabsModel {
  final bool isSuccess;
  final String message;
  final CustomTabsData data;

  CustomTabsModel({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory CustomTabsModel.fromJson(Map<String, dynamic>? json) {
    final j = json ?? {};
    return CustomTabsModel(
      isSuccess: j['is_success'] as bool? ?? false,
      message: j['message'] as String? ?? '',
      data: CustomTabsData.fromJson(j['data'] as Map<String, dynamic>?),
    );
  }

  Map<String, dynamic> toJson() => {
    'is_success': isSuccess,
    'message': message,
    'data': data.toJson(),
  };
}

class CustomTabsData {
  final int currentPage;
  final List<CustomTab> data;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<PaginationLink> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  CustomTabsData({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory CustomTabsData.fromJson(Map<String, dynamic>? json) {
    final j = json ?? {};
    final rawData = j['data'] as List<dynamic>? ?? [];
    final rawLinks = j['links'] as List<dynamic>? ?? [];
    return CustomTabsData(
      currentPage: j['current_page'] as int? ?? 0,
      data:
          rawData
              .map((e) => CustomTab.fromJson(e as Map<String, dynamic>?))
              .toList(),
      firstPageUrl: j['first_page_url'] as String? ?? '',
      from: j['from'] as int? ?? 0,
      lastPage: j['last_page'] as int? ?? 0,
      lastPageUrl: j['last_page_url'] as String? ?? '',
      links:
          rawLinks
              .map((e) => PaginationLink.fromJson(e as Map<String, dynamic>?))
              .toList(),
      nextPageUrl: j['next_page_url'] as String?,
      path: j['path'] as String? ?? '',
      perPage: j['per_page'] as int? ?? 0,
      prevPageUrl: j['prev_page_url'] as String?,
      to: j['to'] as int? ?? 0,
      total: j['total'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'current_page': currentPage,
    'data': data.map((x) => x.toJson()).toList(),
    'first_page_url': firstPageUrl,
    'from': from,
    'last_page': lastPage,
    'last_page_url': lastPageUrl,
    'links': links.map((x) => x.toJson()).toList(),
    'next_page_url': nextPageUrl,
    'path': path,
    'per_page': perPage,
    'prev_page_url': prevPageUrl,
    'to': to,
    'total': total,
  };
}

class PaginationLink {
  final String? url;
  final String label;
  final bool active;

  PaginationLink({this.url, required this.label, required this.active});

  factory PaginationLink.fromJson(Map<String, dynamic>? json) {
    final j = json ?? {};
    return PaginationLink(
      url: j['url'] as String?,
      label: j['label'] as String? ?? '',
      active: j['active'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'url': url,
    'label': label,
    'active': active,
  };
}

class CustomTab {
  final int id;
  final String nameAr;
  final String nameEn;
  final int type;
  final int rowType;
  final String typeDescription;
  final List<CustomTabDetail> details;

  CustomTab({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.type,
    required this.rowType,
    required this.typeDescription,
    required this.details,
  });

  factory CustomTab.fromJson(Map<String, dynamic>? json) {
    final j = json ?? {};
    final rawDetails = j['details'] as List<dynamic>? ?? [];
    return CustomTab(
      id: j['id'] as int? ?? 0,
      nameAr: j['name_ar'] as String? ?? '',
      nameEn: j['name_en'] as String? ?? '',
      type: j['type'] as int? ?? 0,
      rowType: j['row_type'] as int? ?? 0,
      typeDescription: j['type_description'] as String? ?? '',
      details:
          rawDetails
              .map((e) => CustomTabDetail.fromJson(e as Map<String, dynamic>?))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name_ar': nameAr,
    'name_en': nameEn,
    'type': type,
    'row_type': rowType,
    'type_description': typeDescription,
    'details': details.map((x) => x.toJson()).toList(),
  };
}

class CustomTabDetail {
  final int id;
  final int customTabId;
  final String nameAr;
  final String nameEn;
  final List<int> ids;
  final List<MediaModel> media;

  CustomTabDetail({
    required this.id,
    required this.customTabId,
    required this.nameAr,
    required this.nameEn,
    required this.ids,
    required this.media,
  });

  factory CustomTabDetail.fromJson(Map<String, dynamic>? json) {
    final j = json ?? {};
    final rawIds = j['ids'] as List<dynamic>? ?? [];
    final rawMedia = j['media'] as List<dynamic>? ?? [];
    return CustomTabDetail(
      id: j['id'] as int? ?? 0,
      customTabId: j['custom_tab_id'] as int? ?? 0,
      nameAr: j['name_ar'] as String? ?? '',
      nameEn: j['name_en'] as String? ?? '',
      ids: rawIds.map((e) => e as int? ?? 0).toList(),
      media:
          rawMedia
              .map((e) => MediaModel.fromJson(e as Map<String, dynamic>?))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'custom_tab_id': customTabId,
    'name_ar': nameAr,
    'name_en': nameEn,
    'ids': ids,
    'media': media.map((x) => x.toJson()).toList(),
  };
}

class MediaModel {
  final int id;
  final String name;
  final String url;

  MediaModel({required this.id, required this.name, required this.url});

  factory MediaModel.fromJson(Map<String, dynamic>? json) {
    final j = json ?? {};
    return MediaModel(
      id: j['id'] as int? ?? 0,
      name: j['name'] as String? ?? '',
      url: j['url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'url': url};
}
