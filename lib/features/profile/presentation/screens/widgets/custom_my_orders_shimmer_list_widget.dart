import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/features/profile/presentation/screens/widgets/custom_my_orders_shimmer_card_widget.dart';

class MyOrdersShimmerList extends StatelessWidget {
  const MyOrdersShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemCount: 6,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (_, __) => const MyOrdersShimmerCard(),
    );
  }
}
