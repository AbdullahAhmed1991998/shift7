import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/features/cart/data/models/cart_item_model.dart';
import 'package:shift7_app/features/cart/presentation/screens/widgets/custom_cart_card_content_widget.dart';

class CustomCartCardWidget extends StatelessWidget {
  final int index;
  final CartItemModel item;
  final int quantity;
  final bool isDirty;
  final bool isUpdating;
  final bool disableActions;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;

  const CustomCartCardWidget({
    super.key,
    required this.index,
    required this.item,
    required this.quantity,
    required this.isDirty,
    required this.isUpdating,
    required this.disableActions,
    required this.onQuantityChanged,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            spreadRadius: 2.r,
            blurRadius: 5.r,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: CustomCartCardContentWidget(
        item: item,
        quantity: quantity,
        isDirty: isDirty,
        isUpdating: isUpdating,
        disableActions: disableActions,
        onQuantityChanged: onQuantityChanged,
        onUpdate: onUpdate,
        onDelete: onDelete,
      ),
    );
  }
}
