import 'package:shift7_app/features/app/data/models/product_item_model.dart';

class BestSellersModel {
  final bool isSuccess;
  final String message;
  final BestSellersData? data;
  final dynamic errors;

  BestSellersModel({
    required this.isSuccess,
    required this.message,
    this.data,
    this.errors,
  });

  factory BestSellersModel.fromJson(Map<String, dynamic> json) {
    return BestSellersModel(
      isSuccess: json['is_success'] ?? false,
      message: json['message'] ?? '',
      data:
          json['data'] != null ? BestSellersData.fromJson(json['data']) : null,
      errors: json['errors'],
    );
  }
}

class BestSellersData {
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

  BestSellersData({
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

  factory BestSellersData.fromJson(Map<String, dynamic> json) {
    return BestSellersData(
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
