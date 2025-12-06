import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shift7_app/core/utils/assets/app_icons.dart';

class CustomCachedNetworkImage extends StatefulWidget {
  final String imageUrl;
  final double height;
  final double width;
  final double radius;
  final BoxFit fit;

  const CustomCachedNetworkImage({
    super.key,
    required this.imageUrl,
    required this.height,
    required this.width,
    required this.radius,
    this.fit = BoxFit.cover,
  });

  @override
  State<CustomCachedNetworkImage> createState() =>
      _CustomCachedNetworkImageState();
}

class _CustomCachedNetworkImageState extends State<CustomCachedNetworkImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _logoController;
  late final Animation<double> _logoScale;

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _logoScale = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  Widget _buildAnimatedLogoPlaceholder(double w, double h, double r) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(r),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: w,
        height: h,
        color: Colors.white,
        child: Stack(
          fit: StackFit.expand,
          children: [
            FadeTransition(
              opacity: Tween<double>(
                begin: 0.4,
                end: 0.9,
              ).animate(_logoController),
              child: ScaleTransition(
                scale: _logoScale,
                child: Center(
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.grey.withAlpha(10),
                      BlendMode.srcATop,
                    ),
                    child: SvgPicture.asset(
                      AppIcons.appIcon,
                      width: w,
                      height: h * 0.5,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaticLogoFallback(double w, double h, double r) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(r),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: w,
        height: h,
        color: Colors.white,
        child: Center(
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withAlpha(10),
              BlendMode.srcATop,
            ),
            child: SvgPicture.asset(
              AppIcons.appIcon,
              width: w,
              height: h * 0.5,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double w = widget.width;
    final double h = widget.height;
    final double r = widget.radius.r;

    if (widget.imageUrl.trim().isEmpty) {
      return _buildStaticLogoFallback(w, h, r);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(r),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: w,
        height: h,
        child: CachedNetworkImage(
          imageUrl: widget.imageUrl,
          fit: widget.fit,
          fadeInDuration: const Duration(milliseconds: 250),
          fadeOutDuration: const Duration(milliseconds: 120),
          placeholder: (context, url) => _buildAnimatedLogoPlaceholder(w, h, r),
          errorWidget:
              (context, url, error) => _buildStaticLogoFallback(w, h, r),
        ),
      ),
    );
  }
}
