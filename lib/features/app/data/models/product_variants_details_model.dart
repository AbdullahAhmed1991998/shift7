import 'package:shift7_app/features/app/data/models/product_variant_combination_model.dart';

import 'product_attribute_model.dart';

class ProductVariantsDetailsModel {
  final Map<String, List<ProductAttributeModel>> attributes;
  final List<ProductVariantCombinationModel> combinations;

  ProductVariantsDetailsModel({
    required this.attributes,
    required this.combinations,
  });

  factory ProductVariantsDetailsModel.fromJson(Map<String, dynamic> json) {
    Map<String, List<ProductAttributeModel>> parsedAttributes = {};
    if (json['attributes'] is Map<String, dynamic>) {
      parsedAttributes = (json['attributes'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          (value as List)
              .map((item) => ProductAttributeModel.fromJson(item))
              .toList(),
        ),
      );
    }

    return ProductVariantsDetailsModel(
      attributes: parsedAttributes,
      combinations:
          (json['combinations'] as List)
              .map((item) => ProductVariantCombinationModel.fromJson(item))
              .toList(),
    );
  }
}
