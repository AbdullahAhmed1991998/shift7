import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_form_field.dart';

class CustomPasswordInputField extends StatefulWidget {
  final TextEditingController controller;
  final bool enabled;
  final String hintText;

  const CustomPasswordInputField({
    super.key,
    required this.controller,
    required this.enabled,
    required this.hintText,
  });

  @override
  State<CustomPasswordInputField> createState() =>
      _CustomPasswordInputFieldState();
}

class _CustomPasswordInputFieldState extends State<CustomPasswordInputField> {
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    return CustomAppFormField(
      controller: widget.controller,
      prefixIcon: EvaIcons.lock,
      borderRadius: 12.r,
      cursorColor: AppColors.secondaryColor,
      cursorHeight: 20.h,
      autofocus: false,
      hintText: widget.hintText,
      hintStyle: AppTextStyle.styleGrey12Bold,
      maxLines: 1,
      obscureText: !visible,
      suffixWidget: IconButton(
        onPressed: () => setState(() => visible = !visible),
        icon: Icon(
          visible ? Icons.visibility : Icons.visibility_off,
          color: AppColors.secondaryColor,
          size: 20.sp,
        ),
      ),
      enabled: widget.enabled,
    );
  }
}
