import 'package:shift7_app/features/app/data/models/search_media_model.dart';

class SearchBrandModel {
  final int id;
  final String nameAr;
  final String nameEn;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<SearchMediaModel> media;

  SearchBrandModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    this.createdAt,
    this.updatedAt,
    required this.media,
  });

  factory SearchBrandModel.fromJson(Map<String, dynamic> json) {
    return SearchBrandModel(
      id: json['id'] ?? 0,
      nameAr: json['name_ar'] ?? '',
      nameEn: json['name_en'] ?? '',
      createdAt:
          json['created_at'] != null
              ? DateTime.tryParse(json['created_at'])
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.tryParse(json['updated_at'])
              : null,
      media:
          json['media'] != null
              ? (json['media'] as List)
                  .map((mediaJson) => SearchMediaModel.fromJson(mediaJson))
                  .toList()
              : [],
    );
  }
}
