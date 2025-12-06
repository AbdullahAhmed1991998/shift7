import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/features/introduction/data/model/on_boarding_model.dart';
import 'package:shift7_app/features/introduction/presentation/screens/widgets/custom_navigation_controls_widget.dart';

class CustomOnBoardingBottomContentwidget extends StatelessWidget {
  final OnBoardingModel model;
  final bool isLastPage;
  final VoidCallback onNextPressed;
  final VoidCallback onGetStartedPressed;

  const CustomOnBoardingBottomContentwidget({
    super.key,
    required this.model,
    required this.isLastPage,
    required this.onNextPressed,
    required this.onGetStartedPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * .27,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            model.title,
            style: AppTextStyle.stylePrimary20Bold.copyWith(fontSize: 22.sp),
          ),
          SizedBox(height: 10.h),
          Text(
            model.subtitle,
            style: AppTextStyle.styleGrey14Bold.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          CustomNavigationControlsWidget(
            isLastPage: isLastPage,
            totalPages: OnBoardingModel.onBoardingData.length,
            currentPage: OnBoardingModel.onBoardingData.indexOf(model),
            onNextPressed: onNextPressed,
            onGetStartedPressed: onGetStartedPressed,
          ),
        ],
      ),
    );
  }
}
