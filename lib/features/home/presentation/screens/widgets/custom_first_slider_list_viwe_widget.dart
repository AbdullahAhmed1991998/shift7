import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_slider_image_item_widget.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_slider_shimmer_item_widget.dart';
import 'package:shift7_app/features/introduction/presentation/cubit/intro_cubit.dart';

class CustomFirstSliderListViewWidget extends StatefulWidget {
  const CustomFirstSliderListViewWidget({super.key});

  @override
  State<CustomFirstSliderListViewWidget> createState() =>
      _CustomFirstSliderListViewWidgetState();
}

class _CustomFirstSliderListViewWidgetState
    extends State<CustomFirstSliderListViewWidget> {
  late PageController _pageController;
  int _currentPage = 0;

  static const double _viewportFraction = 0.9;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: _viewportFraction);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double sliderHeight = 150.h;

    return BlocBuilder<IntroCubit, IntroState>(
      builder: (context, state) {
        final storeStatus = state.storeStatus;
        final store = state.storeDetails?.store;

        final sliderMediaItems =
            store?.media.where((m) => m.name == 'slider_images_one').toList() ??
            [];

        if (storeStatus == ApiStatus.loading) {
          return SizedBox(
            height: sliderHeight,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, __) => const CustomSliderShimmerItemWidget(),
              separatorBuilder: (_, __) => SizedBox(width: 10.w),
              itemCount: 5,
            ),
          );
        }

        if (sliderMediaItems.isEmpty) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: sliderHeight,
          width: 1.sw,
          child: PageView.builder(
            controller: _pageController,
            itemCount: sliderMediaItems.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final media = sliderMediaItems[index];
              final isCurrent = index == _currentPage;
              final elevation = isCurrent ? 6.0 : 2.0;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Center(
                  child: CustomSliderImageItemWidget(
                    media: media,
                    elevation: elevation,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
