import 'package:easy_localization/easy_localization.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_form_field.dart';

class CustomSearchWidget extends StatefulWidget {
  const CustomSearchWidget({super.key});

  @override
  State<CustomSearchWidget> createState() => _CustomSearchWidgetState();
}

class _CustomSearchWidgetState extends State<CustomSearchWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: SizedBox(
        height: 48.h,
        width: 343.w,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CustomAppFormField(
            controller: searchController,
            prefixIcon: EvaIcons.search,
            borderRadius: 12.r,
            cursorColor: AppColors.secondaryColor,
            cursorHeight: 20.h,
            autofocus: false,
            hintText: 'search_here'.tr(),
            hintStyle: AppTextStyle.styleGrey12Bold.copyWith(fontSize: 13.sp),
            maxLines: 1,
            readOnly: true,
            onTap:
                () => Navigator.pushNamed(context, AppRoutesKeys.searchResult),
          ),
        ),
      ),
    );
  }
}
