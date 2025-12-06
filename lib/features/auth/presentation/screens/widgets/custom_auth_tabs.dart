import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';

class CustomAuthTabs extends StatelessWidget {
  final int currentIndex;
  final VoidCallback onPhoneTap;
  final VoidCallback onEmailTap;
  final String phoneText;
  final String emailText;

  const CustomAuthTabs({
    super.key,
    required this.currentIndex,
    required this.onPhoneTap,
    required this.onEmailTap,
    required this.phoneText,
    required this.emailText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onPhoneTap,
              child: Container(
                decoration: BoxDecoration(
                  color:
                      currentIndex == 1
                          ? AppColors.secondaryColor
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                alignment: Alignment.center,
                child: Text(
                  phoneText,
                  style: TextStyle(
                    color: currentIndex == 1 ? Colors.white : Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: onEmailTap,
              child: Container(
                decoration: BoxDecoration(
                  color:
                      currentIndex == 0
                          ? AppColors.secondaryColor
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                alignment: Alignment.center,
                child: Text(
                  emailText,
                  style: TextStyle(
                    color: currentIndex == 0 ? Colors.white : Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
