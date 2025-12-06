import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/features/introduction/data/model/get_store_details_model.dart';
import 'custom_slider_shimmer_item_widget.dart';

class CustomSliderImageItemWidget extends StatelessWidget {
  final StoreItemMediaModel media;
  final double elevation;

  const CustomSliderImageItemWidget({
    super.key,
    required this.media,
    this.elevation = 4,
  });

  @override
  Widget build(BuildContext context) {
    if (media.url.isEmpty) {
      return const SizedBox.shrink();
    }
    const double itemAspectRatio = 1370 / 410;

    return SizedBox(
      height: 140.h,
      child: Material(
        elevation: elevation,
        borderRadius: BorderRadius.circular(12.r),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutesKeys.mediaLinksDetails,
                arguments: {
                  'mediaId': media.mediaLinks.id,
                  'mediaName': "ourProducts".tr(),
                },
              );
            },
            child: AspectRatio(
              aspectRatio: itemAspectRatio,
              child: CachedNetworkImage(
                imageUrl: media.url,
                fadeInDuration: const Duration(milliseconds: 300),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                placeholder: (_, __) => const CustomSliderShimmerItemWidget(),
                errorWidget: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
