import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/functions/string_extensions.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/features/home/data/model/custom_tabs_model.dart';
import 'package:shift7_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_tabs_card_widget.dart';
import 'package:shimmer/shimmer.dart';

class CustomTabsWidget extends StatefulWidget {
  final int id;
  final String tabType;

  const CustomTabsWidget({super.key, required this.id, required this.tabType});

  @override
  State<CustomTabsWidget> createState() => _CustomTabsWidgetState();
}

class _CustomTabsWidgetState extends State<CustomTabsWidget> {
  final Map<int, int> _visibleItemsCount = {};
  final Map<int, ScrollController> _scrollControllers = {};
  List<CustomTab> _snapshot = const [];
  bool _locked = false;

  @override
  void initState() {
    super.initState();
    final key = '${widget.id}-${widget.tabType}';
    final s = context.read<HomeCubit>().state;
    final cached = (s.customTabsByKey[key] ?? []) as List<dynamic>;
    if (cached.isNotEmpty) {
      _snapshot = cached.cast<CustomTab>();
      _locked = true;
    } else {
      context.read<HomeCubit>().fetchCustomTabs(
        id: widget.id,
        tabType: widget.tabType,
      );
    }
  }

  @override
  void dispose() {
    for (final c in _scrollControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  ScrollController _initScrollController(int tabIndex, int maxItems) {
    if (_scrollControllers.containsKey(tabIndex)) {
      return _scrollControllers[tabIndex]!;
    }
    final controller = ScrollController();
    controller.addListener(() {
      if (controller.position.pixels >=
          controller.position.maxScrollExtent - 150) {
        setState(() {
          _visibleItemsCount[tabIndex] = (_visibleItemsCount[tabIndex]! + 5)
              .clamp(0, maxItems);
        });
      }
    });
    _scrollControllers[tabIndex] = controller;
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = getIt<CacheHelper>().getData(key: 'language') == 'ar';
    final key = '${widget.id}-${widget.tabType}';

    return BlocConsumer<HomeCubit, HomeState>(
      listenWhen: (p, c) {
        final ps = p.customTabsStatusByKey[key];
        final cs = c.customTabsStatusByKey[key];
        return !_locked && cs == ApiStatus.success && ps != ApiStatus.success;
      },
      listener: (_, s) {
        final fresh = (s.customTabsByKey[key] ?? []) as List<dynamic>;
        _snapshot = fresh.cast<CustomTab>();
        _locked = true;
        setState(() {});
      },
      builder: (context, state) {
        final status = state.customTabsStatusByKey[key] ?? ApiStatus.initial;
        final live = (state.customTabsByKey[key] ?? []) as List<dynamic>;
        final data = _locked ? _snapshot : live.cast<CustomTab>();

        if (status == ApiStatus.loading && data.isEmpty) {
          return Container(
            color: AppColors.secondaryColor.withAlpha(50),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15.h),
              child: const CustomTabsShimmerWidget(),
            ),
          );
        }
        if (status == ApiStatus.error && data.isEmpty) {
          return const SizedBox.shrink();
        }
        if (data.isEmpty) {
          return const SizedBox.shrink();
        }

        final tabsWithDetails =
            data.where((t) => t.details.isNotEmpty).toList();
        if (tabsWithDetails.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          color: AppColors.secondaryColor.withAlpha(50),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(tabsWithDetails.length, (tabIndex) {
                  final tab = tabsWithDetails[tabIndex];
                  final maxItems = tab.details.length;
                  _visibleItemsCount[tabIndex] ??= 10;
                  final visibleItems =
                      tab.details.take(_visibleItemsCount[tabIndex]!).toList();
                  final controller = _initScrollController(tabIndex, maxItems);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isArabic ? tab.nameAr : tab.nameEn.englishTitleCase(),
                        style: AppTextStyle.styleBlack18Bold,
                      ),
                      SizedBox(height: 15.h),
                      SizedBox(
                        height: 260.h,
                        child: ListView.separated(
                          controller: controller,
                          scrollDirection: Axis.horizontal,
                          itemCount: visibleItems.length,
                          separatorBuilder: (_, __) => SizedBox(width: 12.w),
                          itemBuilder: (context, detailIdx) {
                            final detail = visibleItems[detailIdx];
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutesKeys.customTabsDetails,
                                  arguments: {
                                    'tabId': detail.id,
                                    'tabName':
                                        isArabic
                                            ? detail.nameAr
                                            : detail.nameEn.englishTitleCase(),
                                  },
                                );
                              },
                              child: CustomTabsCardWidget(item: detail),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomTabsShimmerWidget extends StatelessWidget {
  const CustomTabsShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280.h,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 6,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          separatorBuilder: (_, __) => SizedBox(width: 12.w),
          itemBuilder:
              (_, index) => Container(
                width: 180.w,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
        ),
      ),
    );
  }
}
