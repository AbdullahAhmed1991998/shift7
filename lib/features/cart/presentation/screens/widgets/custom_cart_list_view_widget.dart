import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/features/cart/data/models/cart_item_model.dart';
import 'package:shift7_app/features/cart/presentation/screens/widgets/custom_cart_card_widget.dart';

class CustomCartListViewWidget extends StatelessWidget {
  final List<int> visibleIndices;
  final List<CartItemModel> items;
  final List<int> localQuantities;
  final Set<int> dirtyIndices;
  final Set<int> updatingIndices;
  final bool isAnyUpdating;
  final void Function(int index, int newQty) onChangeQuantity;
  final void Function(int index) onUpdateItem;
  final void Function(int index) onDelete;

  const CustomCartListViewWidget({
    super.key,
    required this.visibleIndices,
    required this.items,
    required this.localQuantities,
    required this.dirtyIndices,
    required this.updatingIndices,
    required this.isAnyUpdating,
    required this.onChangeQuantity,
    required this.onUpdateItem,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, i) {
          final idx = visibleIndices[i];
          final item = items[idx];
          final qty = localQuantities[idx];
          final isDirty = dirtyIndices.contains(idx);
          final isUpdating = updatingIndices.contains(idx);
          return Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: CustomCartCardWidget(
              index: idx,
              item: item,
              quantity: qty,
              isDirty: isDirty,
              isUpdating: isUpdating,
              disableActions: isAnyUpdating && !isUpdating,
              onQuantityChanged: (q) => onChangeQuantity(idx, q),
              onUpdate: () => onUpdateItem(idx),
              onDelete: () => onDelete(idx),
            ),
          );
        }, childCount: visibleIndices.length),
      ),
    );
  }
}
