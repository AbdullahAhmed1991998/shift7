import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/features/app/presentation/screens/widgets/custom_image_widget.dart';
import 'package:shift7_app/features/app/presentation/screens/widgets/custom_thumbnail_widget.dart';

class CustomImageCarouselWidget extends StatefulWidget {
  final List<String> images;
  final double height;
  final int currentIndex;
  final ValueChanged<int>? onPageChanged;

  const CustomImageCarouselWidget({
    super.key,
    required this.images,
    required this.height,
    required this.currentIndex,
    this.onPageChanged,
  });

  @override
  State<CustomImageCarouselWidget> createState() =>
      _CustomImageCarouselWidgetState();
}

class _CustomImageCarouselWidgetState extends State<CustomImageCarouselWidget> {
  late PageController _pageController;
  late ScrollController _thumbnailController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    _pageController = PageController(initialPage: widget.currentIndex);
    _thumbnailController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.images.length > 1) {
        _scrollToSelectedThumbnail(_currentIndex);
      }
    });
  }

  void _scrollToSelectedThumbnail(int index) {
    if (!_thumbnailController.hasClients) return;

    final double itemWidth = 80.w + 12.w;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double offset =
        (index * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

    _thumbnailController.animateTo(
      offset.clamp(0.0, _thumbnailController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onThumbnailTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _scrollToSelectedThumbnail(index);
    widget.onPageChanged?.call(index);
  }

  double _calculateCenterPadding() {
    final double itemWidth = 80.w + 12.w;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double totalItemsWidth = (widget.images.length * itemWidth) - 12.w;
    final double padding = (screenWidth - totalItemsWidth) / 2;
    return padding > 20.w ? padding : 20.w;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _thumbnailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = getIt<CacheHelper>().getData(key: 'language') == 'ar';
    return SizedBox(
      height:
          widget.images.length <= 1
              ? MediaQuery.of(context).size.height * 0.35
              : MediaQuery.of(context).size.height * 0.45,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height:
                widget.images.length <= 1
                    ? MediaQuery.of(context).size.height * 0.35
                    : MediaQuery.of(context).size.height * 0.3,
            child: Stack(
              children: [
                Container(
                  color: Colors.white,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: widget.images.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                      if (widget.images.length > 1) {
                        _scrollToSelectedThumbnail(index);
                      }
                      widget.onPageChanged?.call(index);
                    },
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: CustomImageWidget(
                          imageUrl: widget.images[index],
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 10.h,
                  left: 10.w,
                  child: RotatedBox(
                    quarterTurns: isArabic ? 2 : 0,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.blackColor,
                        size: 24.sp,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (widget.images.length > 1) ...[
            SizedBox(height: 10.h),
            Expanded(
              child: ListView.separated(
                controller: _thumbnailController,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(
                  horizontal: _calculateCenterPadding(),
                ),
                itemCount: widget.images.length,
                separatorBuilder: (context, index) => SizedBox(width: 12.w),
                itemBuilder: (context, index) {
                  final bool isSelected = index == _currentIndex;
                  return GestureDetector(
                    onTap: () => _onThumbnailTap(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 80.w,
                      height: 80.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color:
                              isSelected
                                  ? AppColors.primaryColor
                                  : Colors.transparent,
                          width: isSelected ? 3 : 0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                isSelected
                                    ? AppColors.primaryColor.withAlpha(76)
                                    : Colors.black.withAlpha(25),
                            blurRadius: isSelected ? 12 : 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: CustomThumbnailWidget(
                          imageUrl: widget.images[index],
                          isSelected: isSelected,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ],
      ),
    );
  }
}
