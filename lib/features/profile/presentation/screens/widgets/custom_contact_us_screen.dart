import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shift7_app/core/utils/assets/app_icons.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_home_error_widget.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_empty_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomContactUsScreen extends StatelessWidget {
  const CustomContactUsScreen({super.key});

  String _iconFor(String name) {
    final p = name.toLowerCase();
    if (p.contains('whats')) return AppIcons.whatsAppIcon;
    if (p.contains('insta')) return AppIcons.instagramIcon;
    if (p.contains('face')) return AppIcons.facebookIcon;
    if (p.contains('x') || p.contains('twitter')) return AppIcons.twitterIcon;
    if (p.contains('site') || p.contains('web') || p.contains('website')) {
      return AppIcons.websiteIcon;
    }
    return AppIcons.websiteIcon;
  }

  Future<void> _openUrl(String url) async {
    final u = url.trim();
    if (u.isEmpty) return;
    final ok = await canLaunchUrlString(u);
    if (ok) {
      await launchUrlString(u, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen:
          (p, c) =>
              p.socialStatus != c.socialStatus || p.socialData != c.socialData,
      builder: (context, state) {
        if (state.socialStatus == ApiStatus.error) {
          return Center(
            child: CustomHomeErrorWidget(
              onRetry: () => context.read<ProfileCubit>().getSocialMedia(),
            ),
          );
        }

        if (state.socialStatus == ApiStatus.loading) {
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: AppColors.secondaryColor,
              size: 36.sp,
            ),
          );
        }

        final items =
            (state.socialData?.data ?? [])
                .where(
                  (e) =>
                      e.status == 1 &&
                      e.name.trim().isNotEmpty &&
                      e.url.trim().isNotEmpty,
                )
                .toList();

        if (items.isEmpty) {
          return Center(
            child: CustomEmptyWidget(message: 'noSocialLinksAvailable'.tr()),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.all(16.w),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final item = items[index];
                  return GestureDetector(
                    onTap: () => _openUrl(item.url),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(8.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withAlpha(30),
                            blurRadius: 4.r,
                            offset: Offset(0, 2.h),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            _iconFor(item.name),
                            width: 24.w,
                            height: 24.h,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              item.name,
                              style: AppTextStyle.styleBlack16W500,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }, childCount: items.length),
              ),
            ),
          ],
        );
      },
    );
  }
}
