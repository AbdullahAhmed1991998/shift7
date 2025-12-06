import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';

class CustomProductDescriptionWidget extends StatefulWidget {
  final String description;
  const CustomProductDescriptionWidget({super.key, required this.description});

  @override
  State<CustomProductDescriptionWidget> createState() =>
      _CustomProductDescriptionWidgetState();
}

class _CustomProductDescriptionWidgetState
    extends State<CustomProductDescriptionWidget> {
  // bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // final t = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(height: 5.h),
          Text(
            widget.description,
            textAlign: TextAlign.start,
            style: AppTextStyle.styleBlack14W500.copyWith(fontSize: 13.sp),
          ),
          // AnimatedCrossFade(
          //   firstChild:
          //   secondChild: Text(
          //     widget.description,
          //     style: AppTextStyle.styleBlack14W500.copyWith(fontSize: 13.sp),
          //   ),
          //   crossFadeState:
          //       _isExpanded
          //           ? CrossFadeState.showSecond
          //           : CrossFadeState.showFirst,
          //   duration: const Duration(milliseconds: 300),
          // ),
          // TextButton(
          //   onPressed: () {
          //     setState(() {
          //       _isExpanded = !_isExpanded;
          //     });
          //   },
          //   child: Text(
          //     _isExpanded ? t.showLess : t.showMore,
          //     style: AppTextStyle.styleBlack12W400.copyWith(
          //       color: AppColors.primaryColor,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
