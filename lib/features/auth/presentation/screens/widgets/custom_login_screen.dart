import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shift7_app/core/functions/phone_validator.dart';
import 'package:shift7_app/core/functions/show_toast.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/core/services/cache_helper_keys.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/core/utils/assets/app_icons.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_bottom.dart';
import 'package:shift7_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shift7_app/features/auth/presentation/screens/widgets/custom_email_input_field.dart';
import 'package:shift7_app/features/auth/presentation/screens/widgets/custom_auth_tabs.dart';
import 'package:shift7_app/features/auth/presentation/screens/widgets/custom_password_input_field.dart';
import 'package:shift7_app/features/auth/presentation/screens/widgets/custom_phone_input_field.dart';
import 'package:shift7_app/features/cart/presentation/screens/widgets/custom_dashed_divider.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomLoginScreen extends StatefulWidget {
  final PageController pageController;
  final Function(String)? onNavigateToVerifyEmail;
  final Function(String)? onNavigateToVerifyPhone;

  const CustomLoginScreen({
    super.key,
    required this.pageController,
    this.onNavigateToVerifyEmail,
    this.onNavigateToVerifyPhone,
  });

  @override
  State<CustomLoginScreen> createState() => _CustomLoginScreenState();
}

class _CustomLoginScreenState extends State<CustomLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  bool isEmailLoading = false;
  bool isGoogleLoading = false;
  int loginTabIndex = 1;
  String selectedFullPhone = '';
  String selectedCountryCode = '+962';
  bool _otpSentForCurrentLogin = false;

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool _validateInputs() {
    if (loginTabIndex == 0) {
      final email = emailController.text.trim();
      final emailReg = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,}$');
      if (!emailReg.hasMatch(email)) {
        showToast(
          context,
          isSuccess: false,
          message: "enter_valid_email".tr(),
          icon: Icons.error,
        );
        return false;
      }
    } else {
      final phoneE164 = normalizeDigits(selectedFullPhone.trim());
      if (phoneE164.isEmpty ||
          !validatePhoneByCountry(
            e164: phoneE164,
            dialCode: selectedCountryCode,
          )) {
        showToast(
          context,
          isSuccess: false,
          message: phoneErrorMessage(context, selectedCountryCode),
          icon: Icons.error,
        );
        return false;
      }
    }
    if (passwordController.text.trim().length < 6) {
      showToast(
        context,
        isSuccess: false,
        message: "password_min_length".tr(),
        icon: Icons.error,
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) async {
        if (state.loginStatus == ApiStatus.loading) {
          setState(() {
            isEmailLoading = true;
            isGoogleLoading = false;
            _otpSentForCurrentLogin = false;
          });
          return;
        }

        if (state.googleStatus == ApiStatus.loading) {
          setState(() {
            isGoogleLoading = true;
            isEmailLoading = false;
          });
          return;
        }

        if (state.loginStatus == ApiStatus.success) {
          setState(() {
            isEmailLoading = false;
          });

          if (state.requiresOtp == true) {
            if (_otpSentForCurrentLogin) {
              return;
            }
            _otpSentForCurrentLogin = true;

            if (loginTabIndex == 0) {
              final email = emailController.text.trim();
              widget.onNavigateToVerifyEmail?.call(email);
              context.read<AuthCubit>().sendOtp(email: email, type: 'email');
            } else {
              final normalizedPhone = normalizeDigits(selectedFullPhone);
              widget.onNavigateToVerifyPhone?.call(normalizedPhone);
              context.read<AuthCubit>().sendOtp(
                phone: normalizedPhone,
                type: 'whatsapp',
              );
            }

            widget.pageController.jumpToPage(2);
            return;
          }

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
        } else if (state.loginStatus == ApiStatus.error) {
          setState(() {
            isEmailLoading = false;
            _otpSentForCurrentLogin = false;
          });
          showToast(
            context,
            isSuccess: false,
            message: state.errorMessage ?? "auth_failed".tr(),
            icon: Icons.error,
          );
        }

        if (state.googleStatus == ApiStatus.success) {
          setState(() {
            isGoogleLoading = false;
          });
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
        } else if (state.googleStatus == ApiStatus.error) {
          setState(() {
            isGoogleLoading = false;
          });
          showToast(
            // ignore: use_build_context_synchronously
            context,
            isSuccess: false,
            message: state.errorMessage ?? "auth_failed".tr(),
            icon: Icons.error,
          );
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: 20.h),
                CustomAuthTabs(
                  currentIndex: loginTabIndex,
                  onPhoneTap: () => setState(() => loginTabIndex = 1),
                  onEmailTap: () => setState(() => loginTabIndex = 0),
                  phoneText: "login_by_phone".tr(),
                  emailText: "login_by_email".tr(),
                ),
                SizedBox(height: 30.h),
                if (loginTabIndex == 1)
                  CustomPhoneInputField(
                    controller: phoneController,
                    enabled: state.loginStatus != ApiStatus.loading,
                    hintText: "enter_phone_number".tr(),
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
                    enabled: state.loginStatus != ApiStatus.loading,
                    hintText: "enter_email".tr(),
                  ),
                SizedBox(height: 20.h),
                CustomPasswordInputField(
                  controller: passwordController,
                  enabled: state.loginStatus != ApiStatus.loading,
                  hintText: "enter_password".tr(),
                ),
                TextButton(
                  onPressed: () => widget.pageController.jumpToPage(3),
                  child: Text(
                    "forgot_password".tr(),
                    style: AppTextStyle.styleBlack12W500,
                  ),
                ),
                SizedBox(height: 10.h),
                isEmailLoading
                    ? Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: AppColors.secondaryColor,
                        size: 30.sp,
                      ),
                    )
                    : CustomAppBottom(
                      onTap: () {
                        if (_validateInputs()) {
                          setState(() {
                            isEmailLoading = true;
                            isGoogleLoading = false;
                            _otpSentForCurrentLogin = false;
                          });
                          if (loginTabIndex == 0) {
                            context.read<AuthCubit>().login(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            );
                          } else {
                            context.read<AuthCubit>().login(
                              phone: normalizeDigits(selectedFullPhone),
                              password: passwordController.text.trim(),
                            );
                          }
                        }
                      },
                      backgroundColor: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(12.r),
                      height: 50.h,
                      width: double.infinity,
                      child: Text(
                        "login".tr(),
                        style: AppTextStyle.styleWhite18Bold,
                      ),
                    ),
                SizedBox(height: 15.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .35,
                      child: CustomDashedDivider(
                        color: AppColors.greyColor,
                        height: 15.h,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Text(
                        "or".tr(),
                        style: AppTextStyle.styleGrey14Bold,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .35,
                      child: CustomDashedDivider(
                        color: AppColors.greyColor,
                        height: 15.h,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                isGoogleLoading
                    ? Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: AppColors.secondaryColor,
                        size: 30.sp,
                      ),
                    )
                    : CustomAppBottom(
                      backgroundColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(12.r),
                      height: 50.h,
                      horizontalPadding: 20.w,
                      width: double.infinity,
                      hasBorder: true,
                      onTap: () {
                        setState(() {
                          isGoogleLoading = true;
                          isEmailLoading = false;
                        });
                        context.read<AuthCubit>().googleAuth();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            AppIcons.googleIcon,
                            height: 24.h,
                            width: 24.w,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            "continue_with_google".tr(),
                            style: AppTextStyle.styleBlack16W500,
                          ),
                        ],
                      ),
                    ),
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "no_account".tr(),
                      style: AppTextStyle.styleBlack14W500.copyWith(
                        color: Colors.grey,
                        fontSize: 16.sp,
                      ),
                    ),
                    TextButton(
                      onPressed: () => widget.pageController.jumpToPage(1),
                      child: Text(
                        "sign_up".tr(),
                        style: AppTextStyle.styleBlack14W500.copyWith(
                          color: AppColors.secondaryColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
