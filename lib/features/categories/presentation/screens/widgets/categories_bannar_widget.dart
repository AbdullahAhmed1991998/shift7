import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CategoriesBannerWidget extends StatefulWidget {
  final String bannerUrl;
  const CategoriesBannerWidget({super.key, required this.bannerUrl});

  @override
  State<CategoriesBannerWidget> createState() => _CategoriesBannerWidgetState();
}

class _CategoriesBannerWidgetState extends State<CategoriesBannerWidget> {
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    if (widget.bannerUrl.isEmpty || _hasError) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: AspectRatio(
        aspectRatio: 375.w / 80.h,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: CachedNetworkImage(
            imageUrl: widget.bannerUrl,
            fadeInDuration: const Duration(milliseconds: 300),
            fit: BoxFit.fitWidth,
            placeholder:
                (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(color: Colors.grey[300]),
                ),
            errorWidget: (context, url, error) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    _hasError = true;
                  });
                }
              });
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
