import 'package:shift7_app/core/functions/parsing_utils.dart';
import 'cart_item_model.dart';

class CartStoreGroupModel {
  final int storeId;
  final int? marketId;
  final String storeNameAr;
  final String storeNameEn;
  final String? marketNameAr;
  final String? marketNameEn;
  final List<CartItemModel> items;

  const CartStoreGroupModel({
    required this.storeId,
    required this.storeNameAr,
    required this.storeNameEn,
    required this.items,
    this.marketId,
    this.marketNameAr,
    this.marketNameEn,
  });

  factory CartStoreGroupModel.fromJson(Map<String, dynamic> json) {
    final rawItems = asList(json['items']);
    return CartStoreGroupModel(
      storeId: asInt(json['store_id']),
      marketId: json['market_id'],
      storeNameAr: asString(json['store_name_ar']),
      storeNameEn: asString(json['store_name_en']),
      marketNameAr: asString(json['market_name_ar']),
      marketNameEn: asString(json['market_name_en']),
      items: rawItems.map((e) => CartItemModel.fromJson(asMap(e))).toList(),
    );
  }
}
