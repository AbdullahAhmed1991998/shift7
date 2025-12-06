import 'package:shift7_app/features/app/data/models/product_item_model.dart';
import 'package:shift7_app/features/introduction/data/model/get_store_details_model.dart';
import 'category_item_model.dart';

class CategoriesProductsListModel {
  final bool isSuccess;
  final String message;
  final int id;
  final String nameAr;
  final String nameEn;
  final String slug;
  final int isMarket;
  final int? parentId;
  final int storeId;
  final bool hasSubcategories;
  final List<StoreMarketMediaModel> media;
  final List<ProductItemModel> products;
  final List<CategoryItemModel> subCategories;
  final ProductsPagination? productsPagination;
  final dynamic errors;

  CategoriesProductsListModel({
    required this.isSuccess,
    required this.message,
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.slug,
    required this.isMarket,
    required this.parentId,
    required this.storeId,
    required this.hasSubcategories,
    required this.media,
    required this.products,
    required this.subCategories,
    this.productsPagination,
    this.errors,
  });

  factory CategoriesProductsListModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final category = data['category'] ?? {};
    final productsWrapper = data['products'];
    final productsList =
        productsWrapper != null ? productsWrapper['data'] as List? : null;

    return CategoriesProductsListModel(
      isSuccess: json['is_success'] ?? false,
      message: json['message'] ?? '',
      id: category['id'] ?? 0,
      nameAr: category['name_ar'] ?? '',
      nameEn: category['name_en'] ?? '',
      slug: category['slug'] ?? '',
      isMarket: category['is_market'] ?? 0,
      parentId: category['parent_id'],
      storeId: category['store_id'] ?? 0,
      hasSubcategories: category['has_subcategories'] ?? false,
      media:
          (category['media'] != null)
              ? List<StoreMarketMediaModel>.from(
                (category['media'] as List).map(
                  (e) => StoreMarketMediaModel.fromJson(e),
                ),
              )
              : [],
      products:
          (productsList != null)
              ? productsList
                  .map((e) => ProductItemModel.fromJson(e))
                  .toList()
                  .cast<ProductItemModel>()
              : [],
      subCategories:
          (data['sub_categories'] != null)
              ? List<CategoryItemModel>.from(
                (data['sub_categories'] as List).map(
                  (e) => CategoryItemModel.fromJson(e),
                ),
              )
              : [],
      productsPagination:
          productsWrapper != null
              ? ProductsPagination.fromJson(productsWrapper)
              : null,
      errors: json['errors'],
    );
  }
}

class ProductsPagination {
  final int currentPage;
  final String? firstPageUrl;
  final int? from;
  final int lastPage;
  final String? lastPageUrl;
  final List<PaginationLink> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int? to;
  final int total;

  ProductsPagination({
    required this.currentPage,
    this.firstPageUrl,
    this.from,
    required this.lastPage,
    this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    this.to,
    required this.total,
  });

  factory ProductsPagination.fromJson(Map<String, dynamic> json) {
    return ProductsPagination(
      currentPage: json['current_page'] ?? 1,
      firstPageUrl: json['first_page_url'],
      from: json['from'],
      lastPage: json['last_page'] ?? 1,
      lastPageUrl: json['last_page_url'],
      links:
          (json['links'] != null)
              ? List<PaginationLink>.from(
                (json['links'] as List).map((e) => PaginationLink.fromJson(e)),
              )
              : [],
      nextPageUrl: json['next_page_url'],
      path: json['path'] ?? '',
      perPage: json['per_page'] ?? 10,
      prevPageUrl: json['prev_page_url'],
      to: json['to'],
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
