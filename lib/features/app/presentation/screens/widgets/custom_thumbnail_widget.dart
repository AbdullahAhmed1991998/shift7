import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/assets/app_images.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomThumbnailWidget extends StatelessWidget {
  final String imageUrl;
  final bool isSelected;

  const CustomThumbnailWidget({
    super.key,
    required this.imageUrl,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isEmpty = imageUrl.trim().isEmpty;

    final child =
        isEmpty
            ? Image.asset(
              AppImages.appImage,
              fit: BoxFit.cover,
              width: 80.w,
              height: 80.h,
            )
            : CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              width: 80.w,
              height: 80.h,
              placeholder:
                  (context, url) => Skeletonizer(
                    enabled: true,
                    child: Container(
                      width: 80.w,
                      height: 80.h,
                      color: Colors.grey.shade100,
                    ),
                  ),
              errorWidget:
                  (context, url, error) => Image.asset(
                    AppImages.appImage,
                    fit: BoxFit.cover,
                    width: 80.w,
                    height: 80.h,
                  ),
            );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: Colors.white,
        border:
            isSelected
                ? Border.all(color: Theme.of(context).primaryColor, width: 2)
                : null,
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(10.r), child: child),
    );
  }
}
