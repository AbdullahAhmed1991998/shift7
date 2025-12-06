import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/cache_helper_keys.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/features/app/presentation/screens/widgets/custom_search_widget.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_first_slider_list_viwe_widget.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_best_seller_list_view_widget.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_tabs_widget.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_market_list_view_widget.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_new_arrivals_list_view_item_widget.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_second_slider_and_categories_list_view_widget.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_special_offer_list_viwe_widget.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_main_ad_widget.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_sub_ad_widget.dart';
import 'package:shift7_app/features/introduction/presentation/cubit/intro_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: BlocBuilder<IntroCubit, IntroState>(
        builder: (context, state) {
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(child: SizedBox(height: 15.h)),
              SliverToBoxAdapter(child: CustomSearchWidget()),
              SliverToBoxAdapter(child: SizedBox(height: 15.h)),
              if (state.storeDetails?.store.hasMarket == 1)
                SliverToBoxAdapter(child: CustomMarketListViewWidget()),
              if (state.storeDetails?.store.hasMarket == 1)
                SliverToBoxAdapter(child: SizedBox(height: 5.h)),
              if (state.storeDetails?.store.media
                      .where((m) => m.name == 'slider_images_one')
                      .isNotEmpty ==
                  true)
                SliverToBoxAdapter(child: CustomFirstSliderListViewWidget()),
              if (state.storeDetails?.store.media
                      .where((m) => m.name == 'slider_images_one')
                      .isNotEmpty ==
                  true)
                SliverToBoxAdapter(child: SizedBox(height: 20.h)),
              SliverToBoxAdapter(
                child: CustomSecondSliderAndCategoriesListViewWidget(
                  hasMarkets:
                      state.storeDetails?.store.hasMarket == 1 ? true : false,
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 10.h)),
              if (state.storeDetails?.store.media
                      .where((m) => m.name == 'main_banner_image')
                      .isNotEmpty ==
                  true)
                SliverToBoxAdapter(child: CustomMainAdWidget()),
              if (state.storeDetails?.store.media
                      .where((m) => m.name == 'main_banner_image')
                      .isNotEmpty ==
                  true)
                SliverToBoxAdapter(child: SizedBox(height: 5.h)),
              SliverToBoxAdapter(child: SizedBox(height: 10.h)),
              SliverToBoxAdapter(
                child: CustomSpecialOfferListViewWidget(categoryId: 0),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 15.h)),
              SliverToBoxAdapter(
                child: CustomBestSellerListViewWidget(categoryId: 0),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 15.h)),
              SliverToBoxAdapter(
                child: CustomNewArrivalsListViewItemWidget(categoryId: 0),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 10.h)),
              SliverToBoxAdapter(child: CustomSubAdWidget()),
              SliverToBoxAdapter(child: SizedBox(height: 20.h)),
              SliverToBoxAdapter(
                child: CustomTabsWidget(
                  id: getIt<CacheHelper>().getData(
                    key: CacheHelperKeys.mainStoreId,
                  ),
                  tabType: 'store',
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
