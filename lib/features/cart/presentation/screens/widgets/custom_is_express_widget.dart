import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomIsExpressWidget extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool>? onChanged;

  const CustomIsExpressWidget({
    super.key,
    this.initialValue = false,
    this.onChanged,
  });

  @override
  State<CustomIsExpressWidget> createState() => _CustomIsExpressWidgetState();
}

class _CustomIsExpressWidgetState extends State<CustomIsExpressWidget> {
  late bool _isExpress;

  @override
  void initState() {
    super.initState();
    _isExpress = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Colors.white,
          border: Border.all(color: Colors.grey.withAlpha(20), width: 1.w),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(32),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'expressDeliveryQuestion'.tr(),
                style: AppTextStyle.styleBlack14W500,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 12.w),
            Switch(
              value: _isExpress,
              activeThumbColor: AppColors.primaryColor,
              inactiveTrackColor: Colors.grey[300],
              activeTrackColor: AppColors.primaryColor.withAlpha(20),
              onChanged: (v) {
                setState(() => _isExpress = v);
                widget.onChanged?.call(v);
              },
            ),
          ],
        ),
      ),
    );
  }
}
