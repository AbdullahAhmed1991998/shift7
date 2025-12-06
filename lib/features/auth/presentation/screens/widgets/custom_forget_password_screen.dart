import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
import 'package:shift7_app/features/auth/presentation/screens/widgets/custom_auth_tabs.dart';
import 'package:shift7_app/features/auth/presentation/screens/widgets/custom_email_input_field.dart';
import 'package:shift7_app/features/auth/presentation/screens/widgets/custom_phone_input_field.dart';

class CustomForgetPasswordScreen extends StatefulWidget {
  final PageController pageController;
  final Function(String)? onNavigateToForgetPassEmail;
  final Function(String)? onNavigateToForgetPassPhone;

  const CustomForgetPasswordScreen({
    super.key,
    required this.pageController,
    this.onNavigateToForgetPassEmail,
    this.onNavigateToForgetPassPhone,
  });

  @override
  State<CustomForgetPasswordScreen> createState() =>
      _CustomForgetPasswordScreenState();
}

class _CustomForgetPasswordScreenState
    extends State<CustomForgetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool isLoading = false;

  int tabIndex = 1;
  String selectedFullPhone = '';
  String selectedCountryCode = '+962';

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  bool _validate() {
    if (tabIndex == 1) {
      final e164 = normalizeDigits(selectedFullPhone.trim());
      if (e164.isEmpty ||
          !validatePhoneByCountry(e164: e164, dialCode: selectedCountryCode)) {
        showToast(
          context,
          isSuccess: false,
          message: phoneErrorMessage(context, selectedCountryCode),
          icon: Icons.error,
        );
        return false;
      }
    } else {
      final email = emailController.text.trim();
      final emailReg = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,}$');
      if (!emailReg.hasMatch(email)) {
        showToast(
          context,
          isSuccess: false,
          message: 'enter_valid_email'.tr(),
          icon: Icons.error,
        );
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.resendStatus == ApiStatus.loading) {
          setState(() => isLoading = true);
        } else if (state.resendStatus == ApiStatus.success) {
          setState(() => isLoading = false);
          showToast(
            context,
            isSuccess: true,
            message: 'otp_sent'.tr(),
            icon: Icons.check,
          );
          if (tabIndex == 0) {
            widget.onNavigateToForgetPassEmail?.call(
              emailController.text.trim(),
            );
          } else {
            widget.onNavigateToForgetPassPhone?.call(
              normalizeDigits(selectedFullPhone),
            );
          }
          widget.pageController.jumpToPage(4);
        } else if (state.resendStatus == ApiStatus.error) {
          setState(() => isLoading = false);
          showToast(
            context,
            isSuccess: false,
            message: 'otp_send_failed'.tr(),
            icon: Icons.error,
          );
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'cant_remember_password'.tr(),
                style: AppTextStyle.styleBlack20W500.copyWith(
                  fontWeight: FontWeight.w200,
                  fontSize: 18.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              CustomAuthTabs(
                currentIndex: tabIndex,
                onPhoneTap: () => setState(() => tabIndex = 1),
                onEmailTap: () => setState(() => tabIndex = 0),
                phoneText: 'whatsapp'.tr(),
                emailText: 'email'.tr(),
              ),
              SizedBox(height: 20.h),
              if (tabIndex == 1)
                CustomPhoneInputField(
                  controller: phoneController,
                  enabled: state.resendStatus != ApiStatus.loading,
                  hintText: 'enter_whatsapp_number'.tr(),
                  onFullNumberChanged:
                      (v) => setState(
                        () => selectedFullPhone = normalizeDigits(v),
                      ),
                  onDialCodeChanged:
                      (v) => setState(() => selectedCountryCode = v),
                )
              else
                CustomEmailInputField(
                  controller: emailController,
                  enabled: state.resendStatus != ApiStatus.loading,
                  hintText: 'enter_email'.tr(),
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
                    onTap: () {
                      if (_validate()) {
                        if (tabIndex == 1) {
                          context.read<AuthCubit>().sendOtp(
                            phone: normalizeDigits(selectedFullPhone),
                            type: 'whatsapp',
                          );
                        } else {
                          context.read<AuthCubit>().sendOtp(
                            email: emailController.text.trim(),
                            type: 'email',
                          );
                        }
                      }
                    },
                    backgroundColor: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(12.r),
                    height: 50.h,
                    width: double.infinity,
                    child: Text(
                      'send_otp'.tr(),
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
