import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_home_error_widget.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_empty_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomFaqScreenWidget extends StatelessWidget {
  const CustomFaqScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen:
          (p, c) => p.helpStatus != c.helpStatus || p.helpData != c.helpData,
      builder: (context, state) {
        if (state.helpStatus == ApiStatus.error) {
          return Center(
            child: CustomHomeErrorWidget(
              hasRetry: true,
              onRetry: () => context.read<ProfileCubit>().getHelpCenter(),
            ),
          );
        }

        if (state.helpStatus == ApiStatus.loading) {
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: AppColors.secondaryColor,
              size: 36.sp,
            ),
          );
        }

        final items =
            (state.helpData?.data ?? [])
                .where(
                  (e) =>
                      (e.status == 1) &&
                      e.question.trim().isNotEmpty &&
                      e.answer.trim().isNotEmpty,
                )
                .toList();

        if (items.isEmpty) {
          return Center(
            child: CustomEmptyWidget(message: 'noFaqsAvailable'.tr()),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.all(16.w),
              sliver: SliverList.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final faq = items[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(8.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.blackColor.withAlpha(25),
                          blurRadius: 4.r,
                          offset: Offset(0, 2.h),
                        ),
                      ],
                    ),
                    child: ExpansionTile(
                      shape: const Border(),
                      title: Text(
                        faq.question,
                        style: AppTextStyle.styleBlack14W500.copyWith(
                          fontSize: 15.sp,
                        ),
                      ),
                      iconColor: AppColors.secondaryColor,
                      collapsedIconColor: AppColors.secondaryColor,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16.w),
                          child: Text(
                            faq.answer,
                            style: AppTextStyle.styleBlack14W500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
