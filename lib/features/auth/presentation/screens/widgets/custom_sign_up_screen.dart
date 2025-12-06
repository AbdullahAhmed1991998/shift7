import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shift7_app/core/functions/phone_validator.dart';
import 'package:shift7_app/core/functions/show_toast.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/cache_helper_keys.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/core/utils/assets/app_icons.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_bottom.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_form_field.dart';
import 'package:shift7_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shift7_app/features/auth/presentation/screens/widgets/custom_auth_tabs.dart';
import 'package:shift7_app/features/auth/presentation/screens/widgets/custom_email_input_field.dart';
import 'package:shift7_app/features/auth/presentation/screens/widgets/custom_password_input_field.dart';
import 'package:shift7_app/features/auth/presentation/screens/widgets/custom_phone_input_field.dart';
import 'package:shift7_app/features/cart/presentation/screens/widgets/custom_dashed_divider.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomSignUpScreen extends StatefulWidget {
  final PageController pageController;
  final Function(String)? onNavigateToVerifyEmail;
  final Function(String)? onNavigateToVerifyPhone;

  const CustomSignUpScreen({
    super.key,
    required this.pageController,
    this.onNavigateToVerifyEmail,
    this.onNavigateToVerifyPhone,
  });

  @override
  State<CustomSignUpScreen> createState() => _CustomSignUpScreenState();
}

class _CustomSignUpScreenState extends State<CustomSignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isSignUpLoading = false;
  bool isGoogleLoading = false;

  int signUpTabIndex = 1;
  String selectedFullPhone = '';
  String selectedCountryCode = '+962';

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool _validateInputs() {
    if (nameController.text.trim().isEmpty) {
      showToast(
        context,
        isSuccess: false,
        message: 'enter_valid_name'.tr(),
        icon: Icons.error,
      );
      return false;
    }
    if (signUpTabIndex == 0) {
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
    } else {
      final phoneE164 = normalizeDigits(selectedFullPhone.trim());
      if (phoneE164.isEmpty ||
          !validatePhoneByCountry(
            e164: phoneE164,
            dialCode: selectedCountryCode,
          )) {
        final String errKey =
            selectedCountryCode.startsWith('+962')
                ? 'jordan_phone_error'.tr()
                : selectedCountryCode.startsWith('+20')
                ? 'egypt_phone_error'.tr()
                : selectedCountryCode.startsWith('+966')
                ? 'saudi_phone_error'.tr()
                : 'enter_valid_phone'.tr();
        showToast(
          context,
          isSuccess: false,
          message: errKey.tr(),
          icon: Icons.error,
        );
        return false;
      }
    }
    if (passwordController.text.trim().length < 6) {
      showToast(
        context,
        isSuccess: false,
        message: 'password_min_length'.tr(),
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
        if (state.registerStatus == ApiStatus.loading) {
          setState(() {
            isSignUpLoading = true;
            isGoogleLoading = false;
          });
          return;
        }

        if (state.googleStatus == ApiStatus.loading) {
          setState(() {
            isGoogleLoading = true;
            isSignUpLoading = false;
          });
          return;
        }

        if (state.registerStatus == ApiStatus.success) {
          setState(() {
            isSignUpLoading = false;
          });

          if (signUpTabIndex == 0) {
            widget.onNavigateToVerifyEmail?.call(emailController.text.trim());
          } else {
            widget.onNavigateToVerifyPhone?.call(
              normalizeDigits(selectedFullPhone),
            );
          }

          widget.pageController.jumpToPage(2);
        } else if (state.registerStatus == ApiStatus.error) {
          setState(() {
            isSignUpLoading = false;
          });
          showToast(
            context,
            isSuccess: false,
            message: state.errorMessage ?? 'auth_failed'.tr(),
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
            context,
            isSuccess: false,
            message: state.errorMessage ?? 'auth_failed'.tr(),
            icon: Icons.error,
          );
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20.h),
                CustomAuthTabs(
                  currentIndex: signUpTabIndex,
                  onPhoneTap: () => setState(() => signUpTabIndex = 1),
                  onEmailTap: () => setState(() => signUpTabIndex = 0),
                  phoneText: 'sign_up_by_phone'.tr(),
                  emailText: 'sign_up_by_email'.tr(),
                ),
                SizedBox(height: 20.h),
                CustomAppFormField(
                  controller: nameController,
                  prefixIcon: Icons.person,
                  borderRadius: 12.r,
                  cursorColor: AppColors.secondaryColor,
                  cursorHeight: 20.h,
                  autofocus: false,
                  hintText: 'enter_your_name'.tr(),
                  hintStyle: AppTextStyle.styleGrey12Bold,
                  maxLines: 1,
                  enabled: state.registerStatus != ApiStatus.loading,
                ),
                SizedBox(height: 20.h),
                signUpTabIndex == 0
                    ? CustomEmailInputField(
                      controller: emailController,
                      enabled: state.registerStatus != ApiStatus.loading,
                      hintText: 'enter_email'.tr(),
                    )
                    : CustomPhoneInputField(
                      controller: phoneController,
                      enabled: state.registerStatus != ApiStatus.loading,
                      hintText: 'enter_phone_number'.tr(),
                      onFullNumberChanged:
                          (v) => setState(
                            () => selectedFullPhone = normalizeDigits(v),
                          ),
                      onDialCodeChanged:
                          (v) => setState(() => selectedCountryCode = v),
                    ),
                SizedBox(height: 20.h),
                CustomPasswordInputField(
                  controller: passwordController,
                  enabled: state.registerStatus != ApiStatus.loading,
                  hintText: 'enter_password'.tr(),
                ),
                SizedBox(height: 20.h),
                isSignUpLoading
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
                            isSignUpLoading = true;
                            isGoogleLoading = false;
                          });
                          context.read<AuthCubit>().register(
                            name: nameController.text.trim(),
                            email:
                                signUpTabIndex == 0
                                    ? emailController.text.trim()
                                    : null,
                            phone:
                                signUpTabIndex == 1
                                    ? normalizeDigits(selectedFullPhone)
                                    : null,
                            password: passwordController.text.trim(),
                            otpType: signUpTabIndex == 1 ? 'whatsapp' : 'email',
                          );
                        }
                      },
                      backgroundColor: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(12.r),
                      height: 50.h,
                      width: double.infinity,
                      child: Text(
                        'sign_up'.tr(),
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
                        'or'.tr(),
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
                      onTap: () {
                        setState(() {
                          isGoogleLoading = true;
                          isSignUpLoading = false;
                        });
                        context.read<AuthCubit>().googleAuth();
                      },
                      hasBorder: true,
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
                            'continue_with_google'.tr(),
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
                      'have_account'.tr(),
                      style: AppTextStyle.styleBlack14W500.copyWith(
                        color: Colors.grey,
                        fontSize: 16.sp,
                      ),
                    ),
                    TextButton(
                      onPressed: () => widget.pageController.jumpToPage(0),
                      child: Text(
                        'login'.tr(),
                        style: AppTextStyle.styleBlack14W500.copyWith(
                          color: AppColors.secondaryColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
