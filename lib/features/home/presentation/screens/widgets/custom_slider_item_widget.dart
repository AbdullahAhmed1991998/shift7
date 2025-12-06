import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/features/introduction/data/model/get_store_details_model.dart';

class CustomSliderItemWidget extends StatelessWidget {
  final StoreItemMediaModel media;

  const CustomSliderItemWidget({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    if (media.url.isEmpty) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: ColoredBox(
          color: Colors.white,
          child: Center(
            child: CachedNetworkImage(
              imageUrl: media.url,
              fadeInDuration: const Duration(milliseconds: 300),
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
              placeholder: (context, url) => Container(color: Colors.grey[300]),
              errorWidget: (context, url, error) => const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}
