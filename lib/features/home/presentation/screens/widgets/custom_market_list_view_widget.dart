import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/functions/string_extensions.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_empty_widget.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_home_error_widget.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_market_card_item_widget.dart';
import 'package:shift7_app/features/introduction/presentation/cubit/intro_cubit.dart';

class CustomMarketListViewWidget extends StatelessWidget {
  const CustomMarketListViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isArabic = getIt<CacheHelper>().getData(key: 'language') == 'ar';
    final double cardWidth = 200.w;
    final double gap = 12.w;
    return SizedBox(
      height: 200.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: BlocBuilder<IntroCubit, IntroState>(
                builder: (context, state) {
                  final storeStatus = state.storeStatus;

                  if (storeStatus == ApiStatus.loading) {
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      separatorBuilder: (_, __) => SizedBox(width: gap),
                      itemBuilder:
                          (_, __) => Container(
                            width: cardWidth,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                    );
                  }

                  if (storeStatus == ApiStatus.error) {
                    return const CustomHomeErrorWidget();
                  }

                  if (storeStatus == ApiStatus.success) {
                    final markets = state.storeDetails?.store.markets ?? [];
                    if (markets.isEmpty) {
                      return CustomEmptyWidget(message: "noMarkets".tr());
                    }

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final int n = markets.length;
                        final double totalContentWidth =
                            n * cardWidth + (n - 1) * gap;

                        final bool shouldCenter =
                            totalContentWidth < constraints.maxWidth;

                        final double sidePad =
                            shouldCenter
                                ? (constraints.maxWidth - totalContentWidth) / 2
                                : 0;

                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics:
                              shouldCenter
                                  ? const NeverScrollableScrollPhysics()
                                  : const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: sidePad),
                          itemCount: markets.length,
                          separatorBuilder: (_, __) => SizedBox(width: gap),
                          itemBuilder: (context, index) {
                            final market = markets[index];

                            final nameAr = (market.nameAr).trim();
                            final nameEn = (market.nameEn).trim();
                            final displayName =
                                isArabic
                                    ? (nameAr.isNotEmpty
                                        ? nameAr
                                        : nameEn.englishTitleCase())
                                    : (nameEn.isNotEmpty
                                        ? nameEn.englishTitleCase()
                                        : nameAr);

                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutesKeys.categoryDetails,
                                  arguments: {
                                    'categoryId': market.id,
                                    'categoryName': displayName,
                                  },
                                );
                              },
                              child: SizedBox(
                                width: cardWidth,
                                child: CustomMarketCardItemWidget(
                                  market: market,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
