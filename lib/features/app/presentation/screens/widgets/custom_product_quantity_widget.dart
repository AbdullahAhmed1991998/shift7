import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';

class CustomProductQuantityWidget extends StatefulWidget {
  final int initialQuantity;
  final ValueChanged<int>? onQuantityChanged;

  const CustomProductQuantityWidget({
    super.key,
    this.initialQuantity = 1,
    this.onQuantityChanged,
  });

  @override
  State<CustomProductQuantityWidget> createState() =>
      _CustomProductQuantityWidgetState();
}

class _CustomProductQuantityWidgetState
    extends State<CustomProductQuantityWidget> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.initialQuantity.clamp(1, 9999);
  }

  void onIncrement() {
    setState(() {
      if (quantity < 9999) quantity++;
    });
    widget.onQuantityChanged?.call(quantity);
  }

  void onDecrement() {
    setState(() {
      if (quantity > 1) quantity--;
    });
    widget.onQuantityChanged?.call(quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('quantity'.tr(), style: AppTextStyle.styleBlack16Bold),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 40.h,
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: Colors.grey[200],
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onIncrement,
                  child: FaIcon(
                    FontAwesomeIcons.plus,
                    size: 18.sp,
                    color: AppColors.blackColor,
                  ),
                ),
                SizedBox(width: 15.w),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Text(
                    '$quantity',
                    key: ValueKey<int>(quantity),
                    style: AppTextStyle.styleBlack16Bold,
                  ),
                ),
                SizedBox(width: 15.w),
                GestureDetector(
                  onTap: onDecrement,
                  child: FaIcon(
                    FontAwesomeIcons.minus,
                    size: 18.sp,
                    color: AppColors.blackColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
