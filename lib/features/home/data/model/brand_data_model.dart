import 'package:shift7_app/features/app/data/models/product_item_model.dart';

class BrandDataModel {
  final bool isSuccess;
  final String message;
  final BrandResponseData? data;
  final dynamic errors;

  BrandDataModel({
    required this.isSuccess,
    required this.message,
    this.data,
    this.errors,
  });

  factory BrandDataModel.fromJson(Map<String, dynamic> json) {
    return BrandDataModel(
      isSuccess: json['is_success'] ?? false,
      message: json['message'] ?? '',
      data:
          json['data'] != null
              ? BrandResponseData.fromJson(json['data'])
              : null,
      errors: json['errors'],
    );
  }
}

class BrandResponseData {
  final Brand brand;
  final ProductsPagination products;

  BrandResponseData({required this.brand, required this.products});

  factory BrandResponseData.fromJson(Map<String, dynamic> json) {
    return BrandResponseData(
      brand: Brand.fromJson(json['brand']),
      products: ProductsPagination.fromJson(json['products']),
    );
  }
}

class Brand {
  final int id;
  final String nameAr;
  final String nameEn;
  final List<MediaModel> media;

  Brand({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.media,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'] ?? 0,
      nameAr: json['name_ar'] ?? '',
      nameEn: json['name_en'] ?? '',
      media:
          json['media'] != null
              ? (json['media'] as List)
                  .map((mediaJson) => MediaModel.fromJson(mediaJson))
                  .toList()
              : [],
    );
  }
}

class ProductsPagination {
  final int currentPage;
  final List<ProductItemModel> data;
  final String? firstPageUrl;
  final int from;
  final int lastPage;
  final String? lastPageUrl;
  final List<PaginationLink> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  ProductsPagination({
    required this.currentPage,
    required this.data,
    this.firstPageUrl,
    required this.from,
    required this.lastPage,
    this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory ProductsPagination.fromJson(Map<String, dynamic> json) {
    return ProductsPagination(
      currentPage: json['current_page'] ?? 1,
      data:
          json['data'] != null
              ? (json['data'] as List)
                  .map((productJson) => ProductItemModel.fromJson(productJson))
                  .toList()
              : [],
      firstPageUrl: json['first_page_url'],
      from: json['from'] ?? 0,
      lastPage: json['last_page'] ?? 1,
      lastPageUrl: json['last_page_url'],
      links:
          json['links'] != null
              ? (json['links'] as List)
                  .map((linkJson) => PaginationLink.fromJson(linkJson))
                  .toList()
              : [],
      nextPageUrl: json['next_page_url'],
      path: json['path'] ?? '',
      perPage: json['per_page'] ?? 10,
      prevPageUrl: json['prev_page_url'],
      to: json['to'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}

class PaginationLink {
  final String? url;
  final String label;
  final bool active;

  PaginationLink({this.url, required this.label, required this.active});

  factory PaginationLink.fromJson(Map<String, dynamic> json) {
    return PaginationLink(
      url: json['url'],
      label: json['label'] ?? '',
      active: json['active'] ?? false,
    );
  }
}

class MediaModel {
  final int id;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String url;

  MediaModel({
    required this.id,
    required this.name,
    this.createdAt,
    this.updatedAt,
    required this.url,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      createdAt:
          json['created_at'] != null
              ? DateTime.tryParse(json['created_at'])
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.tryParse(json['updated_at'])
              : null,
      url: json['url'] ?? '',
    );
  }
}
