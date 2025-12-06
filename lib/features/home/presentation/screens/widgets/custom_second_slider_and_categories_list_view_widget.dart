import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom__dual_page_view_slider.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_home_category_list_widget.dart';
import 'package:shift7_app/features/introduction/presentation/cubit/intro_cubit.dart';

class CustomSecondSliderAndCategoriesListViewWidget extends StatelessWidget {
  final bool hasMarkets;
  const CustomSecondSliderAndCategoriesListViewWidget({
    super.key,
    required this.hasMarkets,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IntroCubit, IntroState>(
      builder: (context, introState) {
        return BlocBuilder<CategoriesCubit, CategoriesState>(
          builder: (context, categoryState) {
            if (introState.storeStatus == ApiStatus.error ||
                introState.storeStatus == ApiStatus.success &&
                    introState.storeDetails == null &&
                    categoryState.status == ApiStatus.error) {
              return const SizedBox.shrink();
            }
            return Container(
              color:
                  hasMarkets
                      ? AppColors.whiteColor
                      : AppColors.secondaryColor.withAlpha(20),
              child: CustomScrollView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                slivers: [
                  SliverToBoxAdapter(child: SizedBox(height: 8.h)),
                  SliverToBoxAdapter(child: CustomDualPageViewSlider()),
                  SliverToBoxAdapter(child: SizedBox(height: 8.h)),
                  if (!hasMarkets)
                    const SliverToBoxAdapter(
                      child: CustomHomeCategoryListWidget(),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
