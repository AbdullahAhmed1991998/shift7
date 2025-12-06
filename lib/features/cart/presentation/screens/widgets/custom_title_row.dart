import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:shift7_app/core/utils/style/app_text_style.dart';

class CustomTitleRow extends StatelessWidget {
  final String title;
  final VoidCallback onDelete;

  const CustomTitleRow({
    super.key,
    required this.title,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.3,
          child: Text(
            title,
            style: AppTextStyle.styleBlack18Bold,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        InkWell(
          onTap: onDelete,
          child: Icon(Icons.favorite, color: Colors.red, size: 25.sp),
        ),
      ],
    );
  }
}
