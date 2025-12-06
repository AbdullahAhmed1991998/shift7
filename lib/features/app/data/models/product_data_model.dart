import 'product_item_model.dart';
import 'product_variants_details_model.dart';

class ProductDataModel {
  final ProductItemModel product;
  final ProductVariantsDetailsModel variantsDetails;

  ProductDataModel({required this.product, required this.variantsDetails});

  factory ProductDataModel.fromJson(Map<String, dynamic> json) {
    return ProductDataModel(
      product: ProductItemModel.fromJson(json['product'] ?? {}),
      variantsDetails: ProductVariantsDetailsModel.fromJson(
        json['variants_details'] ?? {},
      ),
    );
  }
}
