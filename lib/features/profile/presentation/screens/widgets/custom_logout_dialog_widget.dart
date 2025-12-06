import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';

class CustomLogoutDialogWidget extends StatefulWidget {
  const CustomLogoutDialogWidget({super.key, required this.onConfirm});

  final Future<void> Function() onConfirm;

  @override
  State<CustomLogoutDialogWidget> createState() =>
      _CustomLogoutDialogWidgetState();
}

class _CustomLogoutDialogWidgetState extends State<CustomLogoutDialogWidget> {
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isProcessing,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(24.w),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.grey.shade50],
            ),
            borderRadius: BorderRadius.circular(28.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(24),
                spreadRadius: 0,
                blurRadius: 30,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: AppColors.primaryColor.withAlpha(30),
                spreadRadius: 0,
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogHeader(),
              _buildDialogContent(),
              _buildDialogActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(32.w, 32.h, 32.w, 16.h),
      child: Column(
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryColor,
                  AppColors.primaryColor.withAlpha(200),
                ],
              ),
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withAlpha(76),
                  spreadRadius: 0,
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(Icons.logout_rounded, color: Colors.white, size: 36.sp),
          ),
          SizedBox(height: 20.h),
          Text(
            "logout".tr(),
            style: AppTextStyle.stylePrimary20Bold.copyWith(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDialogContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Text(
        "logoutConfirmation".tr(),
        style: AppTextStyle.styleBlack16W500.copyWith(
          color: Colors.grey[600],
          fontSize: 16.sp,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDialogActions(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(32.w),
      child: Row(
        children: [
          Expanded(child: _buildCancelButton(context)),
          SizedBox(width: 16.w),
          Expanded(child: _buildLogoutButton()),
        ],
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: TextButton(
        onPressed: isProcessing ? null : () => Navigator.of(context).pop(),
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: Text(
          "cancel".tr(),
          style: AppTextStyle.styleBlack16Bold.copyWith(
            color: Colors.grey[700],
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor.withAlpha(204),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withAlpha(76),
            spreadRadius: 0,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextButton(
        onPressed: isProcessing ? null : _onConfirmPressed,
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child:
            isProcessing
                ? SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                  ),
                )
                : Text(
                  "logout".tr(),
                  style: AppTextStyle.styleBlack16Bold.copyWith(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
      ),
    );
  }

  Future<void> _onConfirmPressed() async {
    setState(() {
      isProcessing = true;
    });

    await widget.onConfirm();

    if (!mounted) return;
    setState(() {
      isProcessing = false;
    });
  }
}
