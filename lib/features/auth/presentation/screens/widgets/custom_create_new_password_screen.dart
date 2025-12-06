import 'package:easy_localization/easy_localization.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shift7_app/core/functions/show_toast.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/core/services/cache_helper_keys.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_bottom.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_form_field.dart';
import 'package:shift7_app/features/auth/presentation/cubit/auth_cubit.dart';

class CustomCreateNewPasswordScreen extends StatefulWidget {
  final PageController pageController;
  final String? email;
  final String? phone;

  const CustomCreateNewPasswordScreen({
    super.key,
    required this.pageController,
    this.email,
    this.phone,
  });

  @override
  State<CustomCreateNewPasswordScreen> createState() =>
      _CustomCreateNewPasswordScreenState();
}

class _CustomCreateNewPasswordScreenState
    extends State<CustomCreateNewPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  bool isLoading = false;

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() => isPasswordVisible = !isPasswordVisible);
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'enter_password'.tr();
    if (value.length < 6) return 'password_min_length'.tr();
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'confirm_password'.tr();
    if (value != passwordController.text) return 'passwords_not_match'.tr();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) async {
        if (state.changePasswordStatus == ApiStatus.loading) {
          setState(() => isLoading = true);
        } else if (state.changePasswordStatus == ApiStatus.success) {
          await getIt<CacheHelper>().setData(
            key: CacheHelperKeys.isLogin,
            value: true,
          );
          setState(() => isLoading = false);
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
        } else if (state.changePasswordStatus == ApiStatus.error) {
          setState(() => isLoading = false);
          showToast(
            context,
            isSuccess: false,
            message: 'auth_failed'.tr(),
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
                CustomAppFormField(
                  controller: passwordController,
                  validator: _validatePassword,
                  prefixIcon: EvaIcons.lock,
                  borderRadius: 12.r,
                  cursorColor: AppColors.secondaryColor,
                  cursorHeight: 20.h,
                  autofocus: false,
                  hintText: 'new_password'.tr(),
                  hintStyle: AppTextStyle.styleGrey12Bold,
                  maxLines: 1,
                  obscureText: !isPasswordVisible,
                  suffixWidget: IconButton(
                    onPressed: _togglePasswordVisibility,
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.secondaryColor,
                      size: 20.sp,
                    ),
                  ),
                  enabled: state.changePasswordStatus != ApiStatus.loading,
                ),
                SizedBox(height: 20.h),
                CustomAppFormField(
                  controller: confirmPasswordController,
                  validator: _validateConfirmPassword,
                  prefixIcon: EvaIcons.lock,
                  borderRadius: 12.r,
                  cursorColor: AppColors.secondaryColor,
                  cursorHeight: 20.h,
                  autofocus: false,
                  hintText: 'confirm_password_title'.tr(),
                  hintStyle: AppTextStyle.styleGrey12Bold,
                  maxLines: 1,
                  obscureText: !isPasswordVisible,
                  suffixWidget: IconButton(
                    onPressed: _togglePasswordVisibility,
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.secondaryColor,
                      size: 20.sp,
                    ),
                  ),
                  enabled: state.changePasswordStatus != ApiStatus.loading,
                ),
                SizedBox(height: 30.h),
                isLoading
                    ? Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: AppColors.secondaryColor,
                        size: 30.sp,
                      ),
                    )
                    : CustomAppBottom(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthCubit>().changePassword(
                            phone: widget.phone,
                            email: widget.email,
                            password: passwordController.text.trim(),
                            confirmPassword:
                                confirmPasswordController.text.trim(),
                          );
                        }
                      },
                      backgroundColor: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(12.r),
                      height: 50.h,
                      width: double.infinity,
                      child: Text(
                        'update_password'.tr(),
                        style: AppTextStyle.styleWhite18Bold,
                      ),
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
