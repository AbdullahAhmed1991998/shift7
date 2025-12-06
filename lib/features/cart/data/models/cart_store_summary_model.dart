import 'package:shift7_app/core/functions/parsing_utils.dart';
import 'package:shift7_app/features/cart/data/models/checkout_cart_item_model.dart';

class CartStoreSummaryModel {
  final int storeId;
  final List<CheckoutCartItemModel> items;
  final String? deliveryMessage;
  final double? deliveryFee;
  final String? deliveryTime;
  final String? deliveryStatus;
  final double? coupon;
  final double? orderTax;
  final double? orderWithoutTax;
  final double? total;
  final double? totalDiscountsFees;
  final double? totalServiceFees;

  const CartStoreSummaryModel({
    required this.storeId,
    required this.items,
    this.deliveryMessage,
    this.deliveryFee,
    this.deliveryTime,
    this.deliveryStatus,
    this.coupon,
    this.orderTax,
    this.orderWithoutTax,
    this.total,
    this.totalDiscountsFees,
    this.totalServiceFees,
  });

  factory CartStoreSummaryModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final parsedItems = <CheckoutCartItemModel>[];

    if (rawItems is List) {
      for (final e in rawItems) {
        if (e is Map) {
          final m = Map<String, dynamic>.from(e);
          parsedItems.add(
            CheckoutCartItemModel(
              productId: asInt(m['product_id']),
              variantId: asInt(m['variant_id']),
              quantity: asInt(m['quantity']),
            ),
          );
        }
      }
    }

    return CartStoreSummaryModel(
      storeId: asInt(json['store_id']),
      items: parsedItems,
      deliveryMessage: json['delivery_message']?.toString(),
      deliveryFee: asDoubleOrNull(json['delivery_fee']),
      deliveryTime: json['delivery_time']?.toString(),
      deliveryStatus: json['delivery_status']?.toString(),
      coupon: asDoubleOrNull(json['coupon']),
      orderTax: asDoubleOrNull(json['tax']),
      orderWithoutTax: asDoubleOrNull(json['subtotal']),
      total: asDoubleOrNull(json['total']),
      totalDiscountsFees: asDoubleOrNull(json['total_discounts_fees']),
      totalServiceFees: asDoubleOrNull(json['total_service_fees']),
    );
  }

  Map<String, dynamic> toJson() => {
    'store_id': storeId,
    'items':
        items
            .map(
              (e) => {
                'product_id': e.productId,
                'variant_id': e.variantId,
                'quantity': e.quantity,
              },
            )
            .toList(),
    'delivery_message': deliveryMessage,
    'delivery_fee': deliveryFee,
    'delivery_time': deliveryTime,
    'delivery_status': deliveryStatus,
    'coupon': coupon,
    'order_tax': orderTax,
    'order_without_tax': orderWithoutTax,
    'total': total,
    'total_discounts_fees': totalDiscountsFees,
    'total_service_fees': totalServiceFees,
  };

  CartStoreSummaryModel copyWith({
    int? storeId,
    List<CheckoutCartItemModel>? items,
    String? deliveryMessage,
    double? deliveryFee,
    String? deliveryTime,
    String? deliveryStatus,
    double? coupon,
    double? orderTax,
    double? orderWithoutTax,
    double? total,
    double? totalDiscountsFees,
    double? totalServiceFees,
  }) {
    return CartStoreSummaryModel(
      storeId: storeId ?? this.storeId,
      items: items ?? this.items,
      deliveryMessage: deliveryMessage ?? this.deliveryMessage,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
      coupon: coupon ?? this.coupon,
      orderTax: orderTax ?? this.orderTax,
      orderWithoutTax: orderWithoutTax ?? this.orderWithoutTax,
      total: total ?? this.total,
      totalDiscountsFees: totalDiscountsFees ?? this.totalDiscountsFees,
      totalServiceFees: totalServiceFees ?? this.totalServiceFees,
    );
  }
}
