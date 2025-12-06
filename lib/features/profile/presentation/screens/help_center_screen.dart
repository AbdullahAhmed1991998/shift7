import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_bar.dart';
import 'package:shift7_app/features/profile/presentation/screens/widgets/custom_contact_us_screen.dart';
import 'package:shift7_app/features/profile/presentation/screens/widgets/custom_faq_screen_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shift7_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:easy_localization/easy_localization.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<ProfileCubit>();
      cubit.getHelpCenter();
      cubit.getSocialMedia();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.h),
        child: CustomAppBar(
          title: 'helpCenterTitle'.tr(),
          onBackPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [Tab(text: 'tabFaq'.tr()), Tab(text: 'tabContactUs'.tr())],
            indicatorColor: AppColors.secondaryColor,
            labelStyle: AppTextStyle.stylePrimary15W500,
            unselectedLabelStyle: AppTextStyle.stylePrimary15W500.copyWith(
              color: Colors.grey[600],
            ),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            splashBorderRadius: BorderRadius.circular(12.r),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                CustomFaqScreenWidget(),
                CustomContactUsScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
