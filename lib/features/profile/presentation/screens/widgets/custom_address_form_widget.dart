import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_form_field.dart';
import 'package:shift7_app/features/profile/presentation/screens/widgets/custom_governorate_dropdown.dart';

class CustomAddressFormWidget extends StatelessWidget {
  final TextEditingController streetController;
  final TextEditingController areaController;
  final TextEditingController governorateController;
  final TextEditingController countryController;
  final TextEditingController zipController;

  final String streetHint;
  final String areaHint;
  final String governorateHint;
  final String countryHint;
  final String zipHint;

  final List<String> governorateItems;
  final void Function(String)? onGovernorateChanged;

  const CustomAddressFormWidget({
    super.key,
    required this.streetController,
    required this.areaController,
    required this.governorateController,
    required this.countryController,
    required this.zipController,
    required this.streetHint,
    required this.areaHint,
    required this.governorateHint,
    required this.countryHint,
    required this.zipHint,
    required this.governorateItems,
    this.onGovernorateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            CustomAppFormField(
              controller: streetController,
              prefixIcon: EvaIcons.home,
              borderRadius: 12.r,
              cursorColor: AppColors.secondaryColor,
              cursorHeight: 20.h,
              autofocus: false,
              hintText: streetHint,
              hintStyle: AppTextStyle.styleBlack14W500,
              maxLines: 1,
              keyboardType: TextInputType.streetAddress,
              enabled: true,
            ),
            SizedBox(height: 10.h),
            CustomAppFormField(
              controller: areaController,
              prefixIcon: EvaIcons.pin,
              borderRadius: 12.r,
              cursorColor: AppColors.secondaryColor,
              cursorHeight: 20.h,
              autofocus: false,
              hintText: areaHint,
              hintStyle: AppTextStyle.styleBlack14W500,
              maxLines: 1,
              keyboardType: TextInputType.text,
              enabled: true,
            ),
            SizedBox(height: 10.h),
            SizedBox(
              width: double.infinity,
              child: CustomGovernorateDropdown(
                items: governorateItems,
                controller: governorateController,
                hintText: governorateHint,
                fillColor: Colors.grey[100],
                onChanged: onGovernorateChanged,
              ),
            ),
            SizedBox(height: 10.h),
            CustomAppFormField(
              controller: countryController,
              prefixIcon: EvaIcons.flag,
              borderRadius: 12.r,
              cursorColor: AppColors.secondaryColor,
              cursorHeight: 20.h,
              autofocus: false,
              hintText: countryHint,
              hintStyle: AppTextStyle.styleBlack14W500,
              maxLines: 1,
              keyboardType: TextInputType.text,
              enabled: true,
            ),
            SizedBox(height: 10.h),
            CustomAppFormField(
              controller: zipController,
              prefixIcon: Icons.numbers,
              borderRadius: 12.r,
              cursorColor: AppColors.secondaryColor,
              cursorHeight: 20.h,
              autofocus: false,
              hintText: zipHint,
              hintStyle: AppTextStyle.styleBlack14W500,
              maxLines: 1,
              keyboardType: TextInputType.number,
              enabled: true,
            ),
            SizedBox(height: 90.h),
          ],
        ),
      ),
    );
  }
}
