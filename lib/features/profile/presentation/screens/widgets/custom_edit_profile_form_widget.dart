import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:shift7_app/core/functions/edit_profile_validators.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_form_field.dart';
import 'package:shift7_app/features/auth/presentation/screens/widgets/custom_phone_input_field.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomEditProfileFormWidget extends StatelessWidget {
  const CustomEditProfileFormWidget({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.fieldsEnabled,
    required this.onFullNumberChanged,
    required this.onDialCodeChanged,
    required this.initialFullNumber,
    required this.defaultIsoCode,
    required this.validators,
    required this.showEmailField,
    required this.showPhoneField,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;

  final bool fieldsEnabled;

  final void Function(String) onFullNumberChanged;
  final void Function(String) onDialCodeChanged;
  final String? initialFullNumber;
  final String defaultIsoCode;

  final EditProfileValidators validators;

  final bool showEmailField;
  final bool showPhoneField;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: nameController,
          builder: (context, value, _) {
            return CustomAppFormField(
              controller: nameController,
              prefixIcon: EvaIcons.person,
              borderRadius: 12.r,
              cursorColor: AppColors.secondaryColor,
              cursorHeight: 20.h,
              autofocus: false,
              hintText: 'nameLabel'.tr(),
              hintStyle: AppTextStyle.styleGrey12Bold,
              maxLines: 1,
              enabled: fieldsEnabled,
              validator: validators.validateName,
            );
          },
        ),
        SizedBox(height: 16.h),

        if (showEmailField)
          CustomAppFormField(
            controller: emailController,
            prefixIcon: EvaIcons.email,
            borderRadius: 12.r,
            cursorColor: AppColors.secondaryColor,
            cursorHeight: 20.h,
            autofocus: false,
            hintText: 'emailLabel'.tr(),
            hintStyle: AppTextStyle.styleGrey12Bold,
            maxLines: 1,
            enabled: fieldsEnabled,
            validator: validators.validateEmail,
          ),
        if (showEmailField) SizedBox(height: 16.h),

        if (showPhoneField)
          CustomPhoneInputField(
            controller: phoneController,
            enabled: fieldsEnabled,
            hintText: 'phoneLabel'.tr(),
            initialFullNumber: initialFullNumber,
            defaultIsoCode: defaultIsoCode,
            onFullNumberChanged: onFullNumberChanged,
            onDialCodeChanged: onDialCodeChanged,
          ),
        if (showPhoneField) SizedBox(height: 16.h),

        if (fieldsEnabled)
          CustomAppFormField(
            controller: passwordController,
            prefixIcon: EvaIcons.lock,
            borderRadius: 12.r,
            cursorColor: AppColors.secondaryColor,
            cursorHeight: 20.h,
            autofocus: false,
            hintText: 'newPasswordOptional'.tr(),
            hintStyle: AppTextStyle.styleGrey12Bold,
            maxLines: 1,
            obscureText: true,
            enabled: fieldsEnabled,
            validator: validators.validatePassword,
          ),
      ],
    );
  }
}
