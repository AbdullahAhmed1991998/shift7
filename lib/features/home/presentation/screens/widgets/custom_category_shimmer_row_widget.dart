import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'category_item_widegt.dart';

class CustomCategoryShimmerRowWidget extends StatelessWidget {
  final int rows;

  const CustomCategoryShimmerRowWidget({super.key, this.rows = 1});

  @override
  Widget build(BuildContext context) {
    const dummyCount = 7;

    return Column(
      children: List.generate(rows, (rowIndex) {
        return Padding(
          padding: EdgeInsets.only(bottom: rowIndex < rows - 1 ? 10.h : 0),
          child: SizedBox(
            height: 135.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: dummyCount,
              separatorBuilder: (_, __) => SizedBox(width: 12.w),
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: CategoryItemWidget(imageUrl: '', title: ''),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
