import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shift7_app/core/functions/phone_validator.dart';
import 'package:shift7_app/core/functions/show_toast.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_bottom.dart';
import 'package:shift7_app/features/auth/presentation/cubit/auth_cubit.dart';

class CustomSendCodeForgetPassScreen extends StatefulWidget {
  final PageController pageController;
  final String? email;
  final String? phone;

  const CustomSendCodeForgetPassScreen({
    super.key,
    required this.pageController,
    this.email,
    this.phone,
  });

  @override
  State<CustomSendCodeForgetPassScreen> createState() =>
      _CustomSendCodeForgetPassScreenState();
}

class _CustomSendCodeForgetPassScreenState
    extends State<CustomSendCodeForgetPassScreen> {
  final controllers = List.generate(6, (_) => TextEditingController());
  final focusNodes = List.generate(6, (_) => FocusNode());
  bool isLoading = false;

  @override
  void dispose() {
    for (final c in controllers) {
      c.dispose();
    }
    for (final f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void onDigitChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  String getVerificationCode() => controllers.map((c) => c.text).join();

  void submitCode() {
    final raw = getVerificationCode();
    final code = normalizeDigits(raw);
    if (code.length == 6 && RegExp(r'^\d{6}$').hasMatch(code)) {
      context.read<AuthCubit>().verifyCodeOfForgetPassword(
        email: widget.email,
        phone: widget.phone,
        otp: code,
      );
    } else {
      showToast(
        context,
        isSuccess: false,
        message: 'enter_valid_code'.tr(),
        icon: Icons.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final message =
        (widget.phone ?? '').isNotEmpty
            ? 'enter_code_whatsapp'.tr()
            : (widget.email ?? '').isNotEmpty
            ? 'enter_code_email'.tr()
            : 'enter_code_sent'.tr();

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.verifyStatus == ApiStatus.loading) {
          setState(() => isLoading = true);
        } else if (state.verifyStatus == ApiStatus.success) {
          setState(() => isLoading = false);
          widget.pageController.jumpToPage(5);
        } else if (state.verifyStatus == ApiStatus.error) {
          setState(() => isLoading = false);
          showToast(
            context,
            isSuccess: false,
            message: 'verification_failed'.tr(),
            icon: Icons.error,
          );
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Text(
                message,
                style: AppTextStyle.styleBlack20W500.copyWith(
                  fontWeight: FontWeight.w200,
                  fontSize: 18.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              Directionality(
                textDirection: ui.TextDirection.ltr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 48.w,
                      height: 48.h,
                      child: TextFormField(
                        controller: controllers[index],
                        focusNode: focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: AppTextStyle.styleBlack18Bold,
                        cursorColor: AppColors.blackColor,
                        maxLength: 1,
                        enabled: state.verifyStatus != ApiStatus.loading,
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(
                              color: AppColors.greyColor,
                              width: 2.w,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(
                              color: AppColors.primaryColor,
                              width: 2.w,
                            ),
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9\u0660-\u0669\u06F0-\u06F9]'),
                          ),
                        ],
                        onChanged: (v) => onDigitChanged(index, v),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 20.h),
              isLoading
                  ? Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      color: AppColors.secondaryColor,
                      size: 30.sp,
                    ),
                  )
                  : CustomAppBottom(
                    onTap: submitCode,
                    backgroundColor: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(12.r),
                    height: 50.h,
                    width: double.infinity,
                    child: Text(
                      'send'.tr(),
                      style: AppTextStyle.styleWhite18Bold,
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }
}
