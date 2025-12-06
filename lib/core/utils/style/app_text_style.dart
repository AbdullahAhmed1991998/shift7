import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';

abstract class AppTextStyle {
  static String get _fontFamily => 'Cairo';

  static TextStyle styleBlack12W500 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.blackColor,
    letterSpacing: -0.1,
    height: 1.3,
  );

  static TextStyle styleBlack18Bold = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.blackColor,
    letterSpacing: -0.2,
    height: 1.4,
  );

  static TextStyle styleBlack20W500 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.blackColor,
    letterSpacing: -0.2,
    height: 1.4,
  );

  static TextStyle styleBlack16W500 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.blackColor,
    letterSpacing: -0.1,
    height: 1.35,
  );

  static TextStyle styleBlack16Bold = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.blackColor,
    letterSpacing: -0.1,
    height: 1.35,
  );

  static TextStyle styleBlack14W500 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.blackColor,
    letterSpacing: -0.05,
    height: 1.3,
  );

  static TextStyle styleBlack12W400 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.blackColor,
    letterSpacing: 0,
    height: 1.3,
  );

  static TextStyle styleGrey600Color12W400 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: Colors.grey[600],
    letterSpacing: 0,
    height: 1.3,
  );

  static TextStyle styleGrey12Bold = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.greyColor,
    letterSpacing: -0.05,
    height: 1.3,
  );

  static TextStyle styleGrey14Bold = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.greyColor,
    letterSpacing: -0.05,
    height: 1.3,
  );

  static TextStyle styleWhite17W700 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 17.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.whiteColor,
    letterSpacing: -0.1,
    height: 1.35,
  );

  static TextStyle styleWhite18Bold = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.whiteColor,
    letterSpacing: -0.2,
    height: 1.4,
  );

  static TextStyle styleWhite18W500 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.whiteColor,
    letterSpacing: -0.1,
    height: 1.4,
  );

  static TextStyle stylePrimary20Bold = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
    letterSpacing: -0.2,
    height: 1.4,
  );

  static TextStyle stylePrimary15Bold = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 15.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
    letterSpacing: -0.1,
    height: 1.35,
  );

  static TextStyle stylePrimary15W500 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 15.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryColor,
    letterSpacing: -0.05,
    height: 1.35,
  );

  static TextStyle stylePrimary16Bold = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
    letterSpacing: -0.1,
    height: 1.35,
  );

  static TextStyle styleSecondary18Bold = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.secondaryColor,
    letterSpacing: -0.2,
    height: 1.4,
  );

  static TextStyle styleSecondary12W500 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.secondaryColor,
    letterSpacing: -0.05,
    height: 1.3,
  );
}
