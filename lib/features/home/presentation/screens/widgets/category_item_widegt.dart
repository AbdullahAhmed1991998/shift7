import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';

class CategoryItemWidget extends StatefulWidget {
  final String imageUrl;
  final String title;

  const CategoryItemWidget({
    super.key,
    required this.imageUrl,
    required this.title,
  });

  @override
  State<CategoryItemWidget> createState() => _CategoryItemWidgetState();
}

class _CategoryItemWidgetState extends State<CategoryItemWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  bool get isLoading => widget.imageUrl == 'loading';

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _fadeAnimation = Tween(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: SizedBox(
        width: 80.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: _buildImage(),
            ),
            SizedBox(height: 10.h),
            _buildTitle(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    if (isLoading) {
      return FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          height: 12.h,
          width: 50.w,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(6.r),
          ),
        ),
      );
    }

    return Container(
      width: 80.w,
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Text(
        widget.title,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyle.styleBlack14W500.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 12.sp,
          height: 1.2,
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (isLoading) {
      return FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          width: 75.w,
          height: 75.w,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      );
    } else if (widget.imageUrl.isEmpty) {
      return Container(
        width: 75.w,
        height: 75.w,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: const Icon(
          Icons.style_rounded,
          size: 30,
          color: AppColors.secondaryColor,
        ),
      );
    } else {
      return CachedNetworkImage(
        imageUrl: widget.imageUrl,
        width: 75.w,
        height: 75.w,
        fit: BoxFit.contain,
        placeholder:
            (context, url) => Container(
              width: 75.w,
              height: 75.w,
              color: Colors.grey.shade300,
            ),
        errorWidget:
            (context, url, error) => Container(
              width: 75.w,
              height: 75.w,
              color: Colors.grey.shade200,
              child: const Icon(
                Icons.style_rounded,
                size: 30,
                color: AppColors.secondaryColor,
              ),
            ),
      );
    }
  }
}
