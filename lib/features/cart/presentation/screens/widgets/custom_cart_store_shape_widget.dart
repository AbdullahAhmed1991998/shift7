import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';

class CustomCartStoreShapeWidget extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomCartStoreShapeWidget({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor =
        selected
            ? (backgroundColor ?? AppColors.primaryColor)
            : Colors.grey[100];
    final borderColor =
        selected
            ? (backgroundColor ?? AppColors.primaryColor)
            : Colors.grey[300];
    final txtColor = selected ? (textColor ?? Colors.white) : Colors.black;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor!),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Center(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: txtColor,
              fontSize: 13.sp,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
