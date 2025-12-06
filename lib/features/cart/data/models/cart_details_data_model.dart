import 'package:shift7_app/core/functions/parsing_utils.dart';
import 'package:shift7_app/features/cart/data/models/cart_store_group_model.dart';

class CartDetailsDataModel {
  final List<CartStoreGroupModel> stores;
  const CartDetailsDataModel({required this.stores});

  factory CartDetailsDataModel.fromJson(Map<String, dynamic> json) {
    final rawStores = asList(json['stores']);
    return CartDetailsDataModel(
      stores:
          rawStores.map((e) => CartStoreGroupModel.fromJson(asMap(e))).toList(),
    );
  }
}
