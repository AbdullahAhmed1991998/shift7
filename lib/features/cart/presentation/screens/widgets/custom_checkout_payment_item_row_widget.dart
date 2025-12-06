import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';

class CustomCheckoutPaymentItemRowWidget extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const CustomCheckoutPaymentItemRowWidget({
    super.key,
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyle.styleBlack16Bold.copyWith(fontSize: 15.sp),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          Text(
            value,
            style:
                isTotal
                    ? AppTextStyle.styleBlack16Bold.copyWith(fontSize: 15.sp)
                    : AppTextStyle.styleBlack14W500,
          ),
        ],
      ),
    );
  }
}
