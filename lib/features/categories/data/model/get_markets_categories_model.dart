class GetMarketsCategoriesModel {
  final bool isSuccess;
  final String message;
  final List<MarketCategoryData> data;
  final dynamic errors;

  GetMarketsCategoriesModel({
    required this.isSuccess,
    required this.message,
    required this.data,
    this.errors,
  });

  factory GetMarketsCategoriesModel.fromJson(Map<String, dynamic> json) {
    return GetMarketsCategoriesModel(
      isSuccess: json['is_success'] as bool,
      message: json['message'] as String,
      data:
          (json['data'] as List<dynamic>)
              .map(
                (e) => MarketCategoryData.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
      errors: json['errors'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_success': isSuccess,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
      'errors': errors,
    };
  }

  GetMarketsCategoriesModel copyWith({
    bool? isSuccess,
    String? message,
    List<MarketCategoryData>? data,
    dynamic errors,
  }) {
    return GetMarketsCategoriesModel(
      isSuccess: isSuccess ?? this.isSuccess,
      message: message ?? this.message,
      data: data ?? this.data,
      errors: errors ?? this.errors,
    );
  }
}

class MarketCategoryData {
  final String marketNameEn;
  final String marketNameAr;
  final PaginatedCategories categories;

  MarketCategoryData({
    required this.marketNameEn,
    required this.marketNameAr,
    required this.categories,
  });

  factory MarketCategoryData.fromJson(Map<String, dynamic> json) {
    return MarketCategoryData(
      marketNameEn: json['market_name_en'] as String,
      marketNameAr: json['market_name_ar'] as String,
      categories: PaginatedCategories.fromJson(
        json['categories'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'market_name_en': marketNameEn,
      'market_name_ar': marketNameAr,
      'categories': categories.toJson(),
    };
  }

  MarketCategoryData copyWith({
    String? marketNameEn,
    String? marketNameAr,
    PaginatedCategories? categories,
  }) {
    return MarketCategoryData(
      marketNameEn: marketNameEn ?? this.marketNameEn,
      marketNameAr: marketNameAr ?? this.marketNameAr,
      categories: categories ?? this.categories,
    );
  }
}

class PaginatedCategories {
  final List<CategoryModel> data;
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;

  PaginatedCategories({
    required this.data,
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  factory PaginatedCategories.fromJson(Map<String, dynamic> json) {
    return PaginatedCategories(
      data:
          (json['data'] as List<dynamic>)
              .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      currentPage: json['current_page'] as int,
      perPage: json['per_page'] as int,
      total: json['total'] as int,
      lastPage: json['last_page'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'current_page': currentPage,
      'per_page': perPage,
      'total': total,
      'last_page': lastPage,
    };
  }

  PaginatedCategories copyWith({
    List<CategoryModel>? data,
    int? currentPage,
    int? perPage,
    int? total,
    int? lastPage,
  }) {
    return PaginatedCategories(
      data: data ?? this.data,
      currentPage: currentPage ?? this.currentPage,
      perPage: perPage ?? this.perPage,
      total: total ?? this.total,
      lastPage: lastPage ?? this.lastPage,
    );
  }
}

class CategoryModel {
  final int id;
  final String nameAr;
  final String nameEn;
  final int? parentId;
  final int storeId;
  final bool hasSubcategories;
  final List<MediaModel> media;

  CategoryModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    this.parentId,
    required this.storeId,
    required this.hasSubcategories,
    required this.media,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      nameAr: json['name_ar'] as String,
      nameEn: json['name_en'] as String,
      parentId: json['parent_id'] as int?,
      storeId: json['store_id'] as int,
      hasSubcategories: json['has_subcategories'] as bool,
      media:
          (json['media'] as List<dynamic>)
              .map((e) => MediaModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_ar': nameAr,
      'name_en': nameEn,
      'parent_id': parentId,
      'store_id': storeId,
      'has_subcategories': hasSubcategories,
      'media': media.map((e) => e.toJson()).toList(),
    };
  }

  CategoryModel copyWith({
    int? id,
    String? nameAr,
    String? nameEn,
    int? parentId,
    int? storeId,
    bool? hasSubcategories,
    List<MediaModel>? media,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      parentId: parentId ?? this.parentId,
      storeId: storeId ?? this.storeId,
      hasSubcategories: hasSubcategories ?? this.hasSubcategories,
      media: media ?? this.media,
    );
  }
}

class MediaModel {
  final int id;
  final String name;
  final String url;

  MediaModel({required this.id, required this.name, required this.url});

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      id: json['id'] as int,
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'url': url};
  }

  MediaModel copyWith({int? id, String? name, String? url}) {
    return MediaModel(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }
}
