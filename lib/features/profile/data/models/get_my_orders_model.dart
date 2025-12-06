import 'package:shift7_app/features/app/data/models/product_item_model.dart';

class GetMyOrdersModel {
  final bool isSuccess;
  final String message;
  final OrdersPagination? data;
  final dynamic errors;

  GetMyOrdersModel({
    required this.isSuccess,
    required this.message,
    this.data,
    this.errors,
  });

  factory GetMyOrdersModel.fromJson(Map<String, dynamic> json) {
    return GetMyOrdersModel(
      isSuccess: json['is_success'] ?? false,
      message: json['message']?.toString() ?? '',
      data:
          json['data'] != null
              ? OrdersPagination.fromJson(json['data'] as Map<String, dynamic>)
              : null,
      errors: json['errors'],
    );
  }

  bool get hasData => data != null && data!.orders.isNotEmpty;
}

class OrdersPagination {
  final int currentPage;
  final List<OrderModel> orders;
  final String firstPageUrl;
  final int? from;
  final int lastPage;
  final String lastPageUrl;
  final List<PaginationLink> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int? to;
  final int total;

  OrdersPagination({
    required this.currentPage,
    required this.orders,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory OrdersPagination.fromJson(Map<String, dynamic> json) {
    return OrdersPagination(
      currentPage: json['current_page'] ?? 1,
      orders:
          (json['data'] as List<dynamic>? ?? [])
              .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      firstPageUrl: json['first_page_url']?.toString() ?? '',
      from: json['from'],
      lastPage: json['last_page'] ?? 1,
      lastPageUrl: json['last_page_url']?.toString() ?? '',
      links:
          (json['links'] as List<dynamic>? ?? [])
              .map((e) => PaginationLink.fromJson(e as Map<String, dynamic>))
              .toList(),
      nextPageUrl: json['next_page_url']?.toString(),
      path: json['path']?.toString() ?? '',
      perPage: _parsePerPage(json['per_page']),
      prevPageUrl: json['prev_page_url']?.toString(),
      to: json['to'],
      total: json['total'] ?? 0,
    );
  }

  static int _parsePerPage(dynamic v) {
    if (v == null) return 10;
    if (v is int) return v;
    if (v is String) {
      return int.tryParse(v) ?? 10;
    }
    return 10;
  }
}

class PaginationLink {
  final String? url;
  final String label;
  final bool active;

  PaginationLink({this.url, required this.label, required this.active});

  factory PaginationLink.fromJson(Map<String, dynamic> json) {
    return PaginationLink(
      url: json['url']?.toString(),
      label: json['label']?.toString() ?? '',
      active: json['active'] ?? false,
    );
  }
}

class OrderModel {
  final int id;
  final int userId;
  final double totalPrice;
  final double subTotalPrice;
  final double taxFee;
  final double serviceFee;
  final double deliveryFee;
  final double coupon;
  final int status;
  final DateTime createdAt;
  final List<OrderItemModel> orderItems;

  OrderModel({
    required this.id,
    required this.userId,
    required this.totalPrice,
    required this.subTotalPrice,
    required this.taxFee,
    required this.serviceFee,
    required this.deliveryFee,
    required this.coupon,
    required this.status,
    required this.createdAt,
    required this.orderItems,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    return OrderModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      totalPrice: parseDouble(json['total_price']),
      subTotalPrice: parseDouble(json['sub_total_price']),
      taxFee: parseDouble(json['tax_fee']),
      serviceFee: parseDouble(json['service_fee']),
      deliveryFee: parseDouble(json['delivery_fee']),
      coupon: parseDouble(json['coupon']),
      status: json['status'] ?? 0,
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      orderItems:
          (json['order_items'] as List<dynamic>? ?? [])
              .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  bool get hasItems => orderItems.isNotEmpty;
}

class OrderItemModel {
  final int id;
  final int orderId;
  final int productId;
  final int? variantId;
  final int quantity;
  final double price;
  final ProductItemModel product;

  OrderItemModel({
    required this.id,
    required this.orderId,
    required this.productId,
    this.variantId,
    required this.quantity,
    required this.price,
    required this.product,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    return OrderItemModel(
      id: json['id'] ?? 0,
      orderId: json['order_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      variantId: json['variant_id'],
      quantity: json['quantity'] ?? 0,
      price: parseDouble(json['price']),
      product: ProductItemModel.fromJson(
        json['product'] as Map<String, dynamic>,
      ),
    );
  }

  double get lineTotal => price * quantity;
}
