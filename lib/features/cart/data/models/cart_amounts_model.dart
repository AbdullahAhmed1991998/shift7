import 'package:shift7_app/core/functions/parsing_utils.dart';

class CartAmounts {
  final double? delivery;

  final double coupon;

  final double total;

  const CartAmounts({this.delivery, required this.coupon, required this.total});

  factory CartAmounts.empty() =>
      const CartAmounts(delivery: null, coupon: 0.0, total: 0.0);

  factory CartAmounts.fromJson(Map<String, dynamic> json) {
    return CartAmounts(
      delivery: asDoubleOrNull(json['delivery']),
      coupon: asDoubleOrNull(json['coupon']) ?? 0.0,
      total: asDoubleOrNull(json['total']) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'delivery': delivery?.toStringAsFixed(2),
    'coupon': coupon,
    'total': total,
  };

  CartAmounts copyWith({double? delivery, double? coupon, double? total}) {
    return CartAmounts(
      delivery: delivery ?? this.delivery,
      coupon: coupon ?? this.coupon,
      total: total ?? this.total,
    );
  }

  double get estimatedGrandTotal => (total - coupon) + (delivery ?? 0.0);
}
