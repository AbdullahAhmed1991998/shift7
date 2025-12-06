import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';

class CustomAppFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final String? errorText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final bool readOnly;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool autofocus;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final Color? cursorColor;
  final TextCapitalization textCapitalization;

  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextStyle? errorStyle;
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final InputBorder? disabledBorder;
  final Color? fillColor;
  final bool filled;
  final bool showCursor;
  final double? cursorHeight;
  final double? cursorWidth;
  final double? borderRadius;

  const CustomAppFormField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixWidget,
    this.suffixWidget,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.autofocus = false,
    this.focusNode,
    this.contentPadding,
    this.cursorColor,
    this.textCapitalization = TextCapitalization.none,

    this.hintStyle,
    this.labelStyle,
    this.errorStyle,
    this.border,
    this.focusedBorder,
    this.errorBorder,
    this.disabledBorder,
    this.fillColor,
    this.filled = true,
    this.showCursor = true,
    this.cursorHeight,
    this.cursorWidth = 2,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius!.r),
      borderSide: BorderSide.none,
    );

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      onTap: onTap,
      readOnly: readOnly,
      enabled: enabled,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      autofocus: autofocus,
      focusNode: focusNode,
      cursorColor: cursorColor ?? AppColors.whiteColor,
      cursorHeight: cursorHeight,
      cursorWidth: cursorWidth!.w,
      showCursor: showCursor,
      textCapitalization: textCapitalization,

      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        helperText: helperText,
        errorText: errorText,
        prefixIcon:
            prefixWidget ??
            (prefixIcon != null
                ? Icon(prefixIcon, color: AppColors.secondaryColor)
                : null),
        suffixIcon:
            suffixWidget ??
            (suffixIcon != null
                ? Icon(suffixIcon, color: AppColors.whiteColor)
                : null),
        filled: filled,
        fillColor: Colors.grey[100],
        contentPadding: contentPadding ?? EdgeInsets.all(16.r),
        border: border ?? defaultBorder,
        enabledBorder: border ?? defaultBorder,
        focusedBorder:
            focusedBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius!.r),
              borderSide: BorderSide(color: AppColors.whiteColor, width: 1.w),
            ),
        errorBorder:
            errorBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius!.r),
              borderSide: BorderSide(color: AppColors.whiteColor, width: 1.w),
            ),
        disabledBorder: disabledBorder ?? defaultBorder,
        hintStyle:
            hintStyle ??
            AppTextStyle.styleBlack14W500.copyWith(
              color: AppColors.whiteColor.withAlpha(127),
            ),
        labelStyle: labelStyle ?? AppTextStyle.styleBlack14W500,
        errorStyle:
            errorStyle ??
            AppTextStyle.styleBlack14W500.copyWith(color: AppColors.whiteColor),
        helperStyle: AppTextStyle.styleBlack14W500.copyWith(
          color: AppColors.whiteColor,
        ),
      ),
    );
  }
}
