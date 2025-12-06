import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shift7_app/core/errors/failures.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/features/cart/data/models/cart_details_response_model.dart';
import 'package:shift7_app/features/cart/data/models/checkout_cart_item_model.dart';
import 'package:shift7_app/features/cart/data/models/get_address_list_model.dart';
import 'package:shift7_app/features/cart/data/models/get_cart_details_model.dart';
import 'package:shift7_app/features/cart/data/repos/cart_repo.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepo repository;
  CartCubit({required this.repository}) : super(CartState.initial());

  void _safeEmit(CartState newState) {
    if (!isClosed) emit(newState);
  }

  Future<void> addToCart({
    required int productId,
    required int quantity,
    int? variantId,
  }) async {
    _safeEmit(
      state.copyWith(addToCartStatus: ApiStatus.loading, errorMessage: ''),
    );
    final result = await repository.addToCart(
      productId: productId,
      quantity: quantity,
      variantId: variantId,
    );
    result.fold(
      (failure) {
        _safeEmit(
          state.copyWith(
            addToCartStatus: ApiStatus.error,
            errorMessage:
                (failure is ServerFailure)
                    ? failure.errorMessage
                    : failure.toString(),
          ),
        );
      },
      (success) {
        _safeEmit(state.copyWith(addToCartStatus: ApiStatus.success));
      },
    );
  }

  Future<void> removeFromCart({required int productId, int? variantId}) async {
    _safeEmit(
      state.copyWith(removeFromCartStatus: ApiStatus.loading, errorMessage: ''),
    );
    final result = await repository.removeFromCart(
      productId: productId,
      variantId: variantId,
    );
    result.fold(
      (failure) {
        _safeEmit(
          state.copyWith(
            removeFromCartStatus: ApiStatus.error,
            errorMessage:
                (failure is ServerFailure)
                    ? failure.errorMessage
                    : failure.toString(),
          ),
        );
      },
      (success) {
        _safeEmit(state.copyWith(removeFromCartStatus: ApiStatus.success));
      },
    );
  }

  Future<void> clearCart() async {
    _safeEmit(
      state.copyWith(clearCartStatus: ApiStatus.loading, errorMessage: ''),
    );
    final result = await repository.clearCart();
    result.fold(
      (failure) {
        _safeEmit(
          state.copyWith(
            clearCartStatus: ApiStatus.error,
            errorMessage:
                (failure is ServerFailure)
                    ? failure.errorMessage
                    : failure.toString(),
          ),
        );
      },
      (success) {
        _safeEmit(state.copyWith(clearCartStatus: ApiStatus.success));
      },
    );
  }

  Future<void> updateCartProduct({
    required int productId,
    required int quantity,
    int? variantId,
  }) async {
    _safeEmit(
      state.copyWith(
        updateCartProductStatus: ApiStatus.loading,
        errorMessage: '',
      ),
    );
    final result = await repository.updateCartProduct(
      productId: productId,
      quantity: quantity,
      variantId: variantId,
    );
    result.fold(
      (failure) {
        _safeEmit(
          state.copyWith(
            updateCartProductStatus: ApiStatus.error,
            errorMessage:
                (failure is ServerFailure)
                    ? failure.errorMessage
                    : failure.toString(),
          ),
        );
      },
      (success) {
        _safeEmit(state.copyWith(updateCartProductStatus: ApiStatus.success));
      },
    );
  }

  Future<void> getCart() async {
    _safeEmit(
      state.copyWith(getCartStatus: ApiStatus.loading, errorMessage: ''),
    );
    final result = await repository.getCart();
    result.fold(
      (failure) {
        _safeEmit(
          state.copyWith(
            getCartStatus: ApiStatus.error,
            errorMessage:
                (failure is ServerFailure)
                    ? failure.errorMessage
                    : failure.toString(),
          ),
        );
      },
      (cart) {
        _safeEmit(
          state.copyWith(getCartStatus: ApiStatus.success, getCart: cart),
        );
      },
    );
  }

  Future<void> checkout({
    int? addressId,
    String? coupon,
    required List<CheckoutCartItemModel> items,
  }) async {
    _safeEmit(
      state.copyWith(checkoutStatus: ApiStatus.loading, errorMessage: ''),
    );
    final result = await repository.checkout(
      addressId: addressId,
      coupon: coupon,
      items: items,
    );
    result.fold(
      (failure) {
        _safeEmit(
          state.copyWith(
            checkoutStatus: ApiStatus.error,
            errorMessage:
                (failure is ServerFailure)
                    ? failure.errorMessage
                    : failure.toString(),
          ),
        );
      },
      (success) {
        _safeEmit(state.copyWith(checkoutStatus: ApiStatus.success));
      },
    );
  }

  Future<void> getAddressList() async {
    _safeEmit(
      state.copyWith(getAddressListStatus: ApiStatus.loading, errorMessage: ''),
    );
    final result = await repository.getAddressList();
    result.fold(
      (failure) {
        _safeEmit(
          state.copyWith(
            getAddressListStatus: ApiStatus.error,
            errorMessage:
                (failure is ServerFailure)
                    ? failure.errorMessage
                    : failure.toString(),
          ),
        );
      },
      (addressList) {
        _safeEmit(
          state.copyWith(
            getAddressListStatus: ApiStatus.success,
            getAddressListModel: addressList,
          ),
        );
      },
    );
  }

  Future<void> getCartDetails({
    int? addressId,
    String? coupon,
    required List<CheckoutCartItemModel> cartItems,
  }) async {
    _safeEmit(
      state.copyWith(getCartDetailsStatus: ApiStatus.loading, errorMessage: ''),
    );
    final result = await repository.getCartDetails(
      addressId: addressId,
      coupon: coupon,
      cartItems: cartItems,
    );
    result.fold(
      (failure) {
        _safeEmit(
          state.copyWith(
            getCartDetailsStatus: ApiStatus.error,
            errorMessage:
                (failure is ServerFailure)
                    ? failure.errorMessage
                    : failure.toString(),
          ),
        );
      },
      (cartDetails) {
        _safeEmit(
          state.copyWith(
            getCartDetailsStatus: ApiStatus.success,
            getCartDetailsModel: cartDetails,
          ),
        );
      },
    );
  }
}
