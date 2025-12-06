import 'package:shift7_app/features/introduction/data/model/store_item_media_model.dart';

class StoreItemDataModel {
  final int id;
  final String nameAr;
  final String nameEn;
  final int isDefault;
  final int hasMarket;
  final List<StoreItemMediaModel> media;

  StoreItemDataModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.isDefault,
    required this.hasMarket,
    required this.media,
  });

  factory StoreItemDataModel.fromJson(Map<String, dynamic> json) {
    return StoreItemDataModel(
      id: json['id'] as int,
      nameAr: json['name_ar'] as String,
      nameEn: json['name_en'] as String,
      isDefault: (json['is_default'] as int),
      hasMarket: (json['has_market'] as int),
      media:
          (json['media'] as List<dynamic>)
              .map(
                (e) => StoreItemMediaModel.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
    );
  }
}
