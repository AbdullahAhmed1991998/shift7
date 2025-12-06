import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_slider_item_widget.dart';
import 'package:shift7_app/features/introduction/data/model/get_store_details_model.dart';

class DualSliderContentWidget extends StatefulWidget {
  final List<StoreItemMediaModel> mediaListOne;
  final List<StoreItemMediaModel> mediaListTwo;

  const DualSliderContentWidget({
    super.key,
    required this.mediaListOne,
    required this.mediaListTwo,
  });

  @override
  State<DualSliderContentWidget> createState() =>
      _DualSliderContentWidgetState();
}

class _DualSliderContentWidgetState extends State<DualSliderContentWidget> {
  late final PageController _leftController;
  late final PageController _rightController;

  int _leftIndex = 0;
  int _rightIndex = 0;

  static final double _itemAspectRatio = 685 / 410;

  @override
  void initState() {
    super.initState();
    _leftController = PageController();
    _rightController = PageController();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _leftController.dispose();
    _rightController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      if (widget.mediaListOne.isNotEmpty) {
        _leftIndex = (_leftIndex + 1) % widget.mediaListOne.length;
        _leftController.animateToPage(
          _leftIndex,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }

      if (widget.mediaListTwo.isNotEmpty) {
        _rightIndex = (_rightIndex - 1) % widget.mediaListTwo.length;
        if (_rightIndex < 0) _rightIndex = widget.mediaListTwo.length - 1;

        _rightController.animateToPage(
          _rightIndex,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }

      _startAutoScroll();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mediaListOne.isEmpty && widget.mediaListTwo.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 120.h,
      child: Row(
        children: [
          if (widget.mediaListOne.isNotEmpty)
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: PageView.builder(
                  controller: _leftController,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (i) => _leftIndex = i,
                  itemCount: widget.mediaListOne.length,
                  itemBuilder:
                      (context, index) => AspectRatio(
                        aspectRatio: _itemAspectRatio,
                        child: CustomSliderItemWidget(
                          media: widget.mediaListOne[index],
                        ),
                      ),
                ),
              ),
            ),
          if (widget.mediaListTwo.isNotEmpty)
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: PageView.builder(
                  controller: _rightController,
                  physics: const ClampingScrollPhysics(),
                  reverse: true,
                  onPageChanged: (i) => _rightIndex = i,
                  itemCount: widget.mediaListTwo.length,
                  itemBuilder:
                      (context, index) => AspectRatio(
                        aspectRatio: _itemAspectRatio,
                        child: CustomSliderItemWidget(
                          media: widget.mediaListTwo[index],
                        ),
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
