part of 'cart_cubit.dart';

class CartState extends Equatable {
  final ApiStatus addToCartStatus;
  final ApiStatus removeFromCartStatus;
  final ApiStatus clearCartStatus;
  final ApiStatus updateCartProductStatus;
  final String errorMessage;
  final ApiStatus getCartStatus;
  final CartDetailsResponseModel? getCart;
  final ApiStatus checkoutStatus;
  final ApiStatus getAddressListStatus;
  final GetAddressListModel? getAddressListModel;
  final ApiStatus getCartDetailsStatus;
  final GetCartDetailsModel? getCartDetailsModel;

  const CartState({
    this.addToCartStatus = ApiStatus.initial,
    this.removeFromCartStatus = ApiStatus.initial,
    this.clearCartStatus = ApiStatus.initial,
    this.updateCartProductStatus = ApiStatus.initial,
    this.getCartStatus = ApiStatus.initial,
    this.checkoutStatus = ApiStatus.initial,
    this.getCart,
    this.errorMessage = '',
    this.getAddressListModel,
    this.getCartDetailsModel,
    this.getAddressListStatus = ApiStatus.initial,
    this.getCartDetailsStatus = ApiStatus.initial,
  });

  factory CartState.initial() {
    return const CartState();
  }

  CartState copyWith({
    ApiStatus? addToCartStatus,
    ApiStatus? removeFromCartStatus,
    ApiStatus? clearCartStatus,
    ApiStatus? updateCartProductStatus,
    String? errorMessage,
    ApiStatus? getCartStatus,
    CartDetailsResponseModel? getCart,
    ApiStatus? checkoutStatus,
    ApiStatus? getAddressListStatus,
    ApiStatus? getCartDetailsStatus,
    GetAddressListModel? getAddressListModel,
    GetCartDetailsModel? getCartDetailsModel,
  }) {
    return CartState(
      addToCartStatus: addToCartStatus ?? this.addToCartStatus,
      removeFromCartStatus: removeFromCartStatus ?? this.removeFromCartStatus,
      clearCartStatus: clearCartStatus ?? this.clearCartStatus,
      updateCartProductStatus:
          updateCartProductStatus ?? this.updateCartProductStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      getCart: getCart ?? this.getCart,
      getCartStatus: getCartStatus ?? this.getCartStatus,
      checkoutStatus: checkoutStatus ?? this.checkoutStatus,
      getAddressListStatus: getAddressListStatus ?? this.getAddressListStatus,
      getCartDetailsStatus: getCartDetailsStatus ?? this.getCartDetailsStatus,
      getAddressListModel: getAddressListModel ?? this.getAddressListModel,
      getCartDetailsModel: getCartDetailsModel ?? this.getCartDetailsModel,
    );
  }

  @override
  List<Object?> get props => [
    addToCartStatus,
    removeFromCartStatus,
    clearCartStatus,
    updateCartProductStatus,
    errorMessage,
    getCartStatus,
    getCart,
    checkoutStatus,
    getAddressListStatus,
    getCartDetailsStatus,
    getAddressListModel,
    getCartDetailsModel,
  ];
}
