import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/features/app/presentation/screens/widgets/custom_shimmer_svg_widget.dart';

class CustomAppBarLoadingWidget extends StatelessWidget {
  const CustomAppBarLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Center(child: const CustomShimmerSvgWidget()),
      ),
    );
  }
}
