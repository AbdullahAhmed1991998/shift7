import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/features/app/data/models/product_item_category_model.dart';
import 'package:shift7_app/features/app/data/models/product_item_media_model.dart';

class FilteredProduct {
  final int id;
  final int brandId;
  final int categoryId;
  final int? storeId;
  final int? modelId;
  final String nameAr;
  final String nameEn;
  final String subNameAr;
  final String subNameEn;
  final String sku;
  final String slug;
  final String basePrice;
  final String costPrice;
  final String tax;
  final int isDisplayed;
  final String? code;
  final int isStock;
  final bool hasVariants;
  final String keyDefaultImage;
  final List<ProductMediaModel> media;
  final int isFreeShipping;
  final double totalDiscountsValue;
  final double? totalRating;
  final bool isWished;
  final bool inCart;
  final ProductItemCategoryModel? category;

  FilteredProduct({
    required this.id,
    required this.brandId,
    required this.categoryId,
    this.storeId,
    this.modelId,
    required this.nameAr,
    required this.nameEn,
    required this.subNameAr,
    required this.subNameEn,
    required this.sku,
    required this.slug,
    required this.basePrice,
    required this.costPrice,
    required this.tax,
    required this.isDisplayed,
    this.code,
    required this.isStock,
    required this.hasVariants,
    required this.keyDefaultImage,
    required this.media,
    required this.isFreeShipping,
    required this.totalDiscountsValue,
    this.totalRating,
    required this.isWished,
    required this.inCart,
    this.category,
  });

  factory FilteredProduct.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0.0;
    }

    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toInt();
      return int.tryParse(value.toString()) ?? 0;
    }

    bool parseBool(dynamic value) {
      if (value is bool) return value;
      if (value is num) return value != 0;
      if (value is String) {
        final v = value.toLowerCase();
        return v == 'true' || v == '1';
      }
      return false;
    }

    final rawDiscount = json['total_discounts_value'];
    final totalDiscount = parseDouble(rawDiscount);

    return FilteredProduct(
      id: parseInt(json['id']),
      brandId: parseInt(json['brand_id']),
      categoryId: parseInt(json['category_id']),
      storeId: json['store_id'] != null ? parseInt(json['store_id']) : null,
      modelId: json['model_id'] != null ? parseInt(json['model_id']) : null,
      nameAr: json['name_ar']?.toString() ?? '',
      nameEn: json['name_en']?.toString() ?? '',
      subNameAr: json['sub_name_ar']?.toString() ?? '',
      subNameEn: json['sub_name_en']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      basePrice: json['base_price']?.toString() ?? '0.00',
      costPrice: json['cost_price']?.toString() ?? '0.00',
      tax: json['tax']?.toString() ?? '0.00',
      isDisplayed: parseInt(json['is_displayed']),
      code: json['code']?.toString(),
      isStock: parseInt(json['is_stock']),
      hasVariants: parseBool(json['has_variants']),
      keyDefaultImage: json['key_default_image']?.toString() ?? '',
      media:
          (json['media'] as List<dynamic>? ?? [])
              .map(
                (item) =>
                    ProductMediaModel.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
      isFreeShipping:
          json['is_free_shipping'] != null
              ? parseInt(json['is_free_shipping'])
              : 0,
      totalDiscountsValue: totalDiscount,
      totalRating:
          json['total_rating'] != null
              ? double.tryParse(json['total_rating'].toString())
              : null,
      isWished: parseBool(json['is_wished']),
      inCart: parseBool(json['in_cart']),
      category:
          json['category'] != null
              ? ProductItemCategoryModel.fromJson(
                json['category'] as Map<String, dynamic>,
              )
              : null,
    );
  }

  String get displayName {
    final isArabic = getIt<CacheHelper>().getData(key: 'language') == 'ar';
    return isArabic ? nameAr : nameEn;
  }

  String get displaySubName {
    final isArabic = getIt<CacheHelper>().getData(key: 'language') == 'ar';
    return isArabic ? subNameAr : subNameEn;
  }

  double get basePriceDouble => double.tryParse(basePrice) ?? 0.0;
  double get costPriceDouble => double.tryParse(costPrice) ?? 0.0;
  double get taxDouble => double.tryParse(tax) ?? 0.0;
  double get discountedPrice {
    final v = basePriceDouble - totalDiscountsValue;
    return v < 0 ? 0.0 : v;
  }

  bool get hasDiscount => totalDiscountsValue > 0.0;

  bool get isAvailable => isDisplayed == 1 && isStock == 1;

  bool get hasImage =>
      keyDefaultImage.isNotEmpty &&
      keyDefaultImage !=
          'https://shift.test.visualinnovate.net/public/images/default.jpg';

  bool get hasMediaImages => media.isNotEmpty;

  String get primaryImage {
    if (hasMediaImages) {
      return media.first.url;
    }
    return keyDefaultImage;
  }

  bool get hasFreeShipping => isFreeShipping != 0;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FilteredProduct && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'FilteredProduct(id: $id, nameAr: $nameAr, brandId: $brandId)';
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

  Map<String, dynamic> toJson() {
    return {'url': url, 'label': label, 'active': active};
  }

  @override
  String toString() =>
      'PaginationLink(url: $url, label: $label, active: $active)';
}

class PaginatedProducts {
  final int currentPage;
  final List<FilteredProduct> data;
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

  PaginatedProducts({
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

  factory PaginatedProducts.fromJson(Map<String, dynamic> json) {
    return PaginatedProducts(
      currentPage: json['current_page'] ?? 1,
      data:
          (json['data'] as List<dynamic>? ?? [])
              .map(
                (item) =>
                    FilteredProduct.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
      firstPageUrl: json['first_page_url'] ?? '',
      from: json['from'] ?? 0,
      lastPage: json['last_page'] ?? 1,
      lastPageUrl: json['last_page_url'] ?? '',
      links:
          (json['links'] as List<dynamic>? ?? [])
              .map(
                (item) => PaginationLink.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
      nextPageUrl: json['next_page_url'],
      path: json['path'] ?? '',
      perPage: json['per_page'] ?? 10,
      prevPageUrl: json['prev_page_url'],
      to: json['to'] ?? 0,
      total: json['total'] ?? 0,
    );
  }

  bool get hasNextPage => nextPageUrl != null;
  bool get hasPreviousPage => prevPageUrl != null;
  bool get isFirstPage => currentPage == 1;
  bool get isLastPage => currentPage == lastPage;
  bool get isEmpty => data.isEmpty;
  bool get isNotEmpty => data.isNotEmpty;

  List<FilteredProduct> get availableProducts =>
      data.where((product) => product.isAvailable).toList();

  List<FilteredProduct> get productsWithImages =>
      data.where((product) => product.hasImage).toList();

  List<int> get brandIds =>
      data.map((product) => product.brandId).toSet().toList();

  List<int> get categoryIds =>
      data.map((product) => product.categoryId).toSet().toList();

  double get totalPrice =>
      data.fold(0.0, (sum, product) => sum + product.discountedPrice);

  double get averagePrice => isEmpty ? 0.0 : totalPrice / data.length;

  @override
  String toString() {
    return 'PaginatedProducts(currentPage: $currentPage, total: $total, data: ${data.length} products)';
  }
}

class FilteredProductsModel {
  final bool isSuccess;
  final String message;
  final PaginatedProducts? data;
  final dynamic errors;

  FilteredProductsModel({
    required this.isSuccess,
    required this.message,
    this.data,
    this.errors,
  });

  factory FilteredProductsModel.fromJson(Map<String, dynamic> json) {
    return FilteredProductsModel(
      isSuccess: json['is_success'] ?? false,
      message: json['message'] ?? '',
      data:
          json['data'] != null
              ? PaginatedProducts.fromJson(json['data'] as Map<String, dynamic>)
              : null,
      errors: json['errors'],
    );
  }

  bool get hasData => data != null && data!.isNotEmpty;
  bool get hasError => !isSuccess || errors != null;

  List<FilteredProduct> get products => data?.data ?? [];
  int get totalProducts => data?.total ?? 0;
  int get currentPage => data?.currentPage ?? 1;
  int get lastPage => data?.lastPage ?? 1;
  bool get hasNextPage => data?.hasNextPage ?? false;
  bool get hasPreviousPage => data?.hasPreviousPage ?? false;

  List<FilteredProduct> get availableProducts => data?.availableProducts ?? [];

  List<FilteredProduct> get productsWithImages =>
      data?.productsWithImages ?? [];

  List<int> get uniqueBrandIds => data?.brandIds ?? [];
  List<int> get uniqueCategoryIds => data?.categoryIds ?? [];

  double get totalPrice => data?.totalPrice ?? 0.0;
  double get averagePrice => data?.averagePrice ?? 0.0;

  @override
  String toString() {
    return 'FilteredProductsModel(isSuccess: $isSuccess, message: $message, totalProducts: $totalProducts)';
  }
}
