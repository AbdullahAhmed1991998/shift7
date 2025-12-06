import 'package:shift7_app/features/app/data/models/search_brand_model.dart';
import 'package:shift7_app/features/app/data/models/search_product_model.dart';
import 'package:shift7_app/features/app/data/models/serach_category_model.dart';

class SearchDataModel {
  final String query;
  final List<SearchCategoryModel> categories;
  final List<SearchBrandModel> brands;
  final List<SearchProductModel> products;

  SearchDataModel({
    required this.query,
    required this.categories,
    required this.brands,
    required this.products,
  });

  factory SearchDataModel.fromJson(Map<String, dynamic> json) {
    return SearchDataModel(
      query: json['query'] ?? '',
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((item) => SearchCategoryModel.fromJson(item))
              .toList() ??
          [],
      brands:
          (json['brands'] as List<dynamic>?)
              ?.map((item) => SearchBrandModel.fromJson(item))
              .toList() ??
          [],
      products:
          (json['products'] as List<dynamic>?)
              ?.map((item) => SearchProductModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}
