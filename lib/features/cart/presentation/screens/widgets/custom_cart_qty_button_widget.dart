import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';

class CustomCartQtyButtonWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const CustomCartQtyButtonWidget({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        width: 34.w,
        height: 34.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: enabled ? AppColors.primaryColor : Colors.grey.shade300,
          ),
          color:
              enabled ? AppColors.primaryColor.withAlpha(16) : Colors.grey[200],
        ),
        child: Icon(
          icon,
          size: 18.sp,
          color: enabled ? AppColors.primaryColor : Colors.grey,
        ),
      ),
    );
  }
}
