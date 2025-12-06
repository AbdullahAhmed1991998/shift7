import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/dual_slider_content_widget.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/dual_slider_loading_widget.dart';
import 'package:shift7_app/features/introduction/presentation/cubit/intro_cubit.dart';

class CustomDualPageViewSlider extends StatefulWidget {
  const CustomDualPageViewSlider({super.key});

  @override
  State<CustomDualPageViewSlider> createState() =>
      _CustomDualPageViewSliderState();
}

class _CustomDualPageViewSliderState extends State<CustomDualPageViewSlider> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IntroCubit, IntroState>(
      builder: (context, state) {
        if (state.storeStatus == ApiStatus.loading) {
          return const DualSliderLoadingWidget();
        } else if (state.storeStatus == ApiStatus.success &&
            state.storeDetails != null) {
          return Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: DualSliderContentWidget(
              mediaListOne:
                  state.storeDetails!.store.media
                      .where((m) => m.name == 'slider_images_two')
                      .toList(),
              mediaListTwo:
                  state.storeDetails!.store.media
                      .where((m) => m.name == 'slider_images_three')
                      .toList(),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
