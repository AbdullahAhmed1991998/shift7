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
import 'package:shift7_app/core/services/cache_helper_keys.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_bottom.dart';
import 'package:shift7_app/features/auth/presentation/cubit/auth_cubit.dart';

class CustomVerifyCodeScreen extends StatefulWidget {
  final PageController pageController;
  final String? verifyEmail;
  final String? verifyPhone;

  const CustomVerifyCodeScreen({
    super.key,
    required this.pageController,
    this.verifyEmail,
    this.verifyPhone,
  });

  @override
  State<CustomVerifyCodeScreen> createState() => _CustomVerifyCodeScreenState();
}

class _CustomVerifyCodeScreenState extends State<CustomVerifyCodeScreen> {
  late String message;
  final _controllers = List.generate(6, (_) => TextEditingController());
  final _focusNodes = List.generate(6, (_) => FocusNode());
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if ((widget.verifyPhone ?? '').isNotEmpty) {
      message = 'enter_code_whatsapp'.tr();
    } else if ((widget.verifyEmail ?? '').isNotEmpty) {
      message = 'enter_code_email'.tr();
    } else {
      message = 'enter_code_sent'.tr();
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onDigitChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  String _getVerificationCode() => _controllers.map((c) => c.text).join();

  void _submitCode() {
    final code = normalizeDigits(_getVerificationCode());
    if (code.length == 6 && RegExp(r'^\d{6}$').hasMatch(code)) {
      context.read<AuthCubit>().verifyEmail(
        email: widget.verifyEmail,
        phone: widget.verifyPhone,
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
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) async {
        if (state.verifyStatus == ApiStatus.loading) {
          setState(() => isLoading = true);
        } else if (state.verifyStatus == ApiStatus.success) {
          setState(() => isLoading = false);

          await getIt<CacheHelper>().setData(
            key: CacheHelperKeys.isLogin,
            value: true,
          );

          if (!mounted) return;
          Navigator.pushReplacementNamed(
            // ignore: use_build_context_synchronously
            context,
            AppRoutesKeys.shift7MainApp,
            arguments: {
              "storeId": getIt<CacheHelper>().getData(
                key: CacheHelperKeys.mainStoreId,
              ),
            },
          );
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
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
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
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) => _onDigitChanged(index, value),
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
                    onTap: _submitCode,
                    backgroundColor: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(12.r),
                    height: 50.h,
                    width: double.infinity,
                    child: Text(
                      'verify'.tr(),
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
