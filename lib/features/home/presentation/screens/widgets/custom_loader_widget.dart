import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:redacted/redacted.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';

class CustomLoaderWidget extends StatelessWidget {
  const CustomLoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder:
            (context, index) => Container(
              width: 160,
              height: 220,
              margin: const EdgeInsets.symmetric(vertical: 24),
              child: SizedBox(
                width: 160.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 160.w,
                      height: 160.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        image: DecorationImage(
                          image: AssetImage(''),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '',
                      style: AppTextStyle.styleBlack16W500,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text('', style: AppTextStyle.styleBlack12W400),
                    SizedBox(height: 4.h),
                    Text('', style: AppTextStyle.stylePrimary16Bold),
                  ],
                ),
              ).redacted(
                context: context,
                redact: true,
                configuration: RedactedConfiguration(
                  animationDuration: const Duration(milliseconds: 800),
                  autoFillTexts: true,
                  redactedColor: Colors.grey[300],
                  defaultBorderRadius: BorderRadius.circular(5.r),
                  autoFillText: '',
                ),
              ),
            ),
      ),
    );
  }
}
