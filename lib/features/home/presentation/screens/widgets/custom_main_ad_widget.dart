import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/features/introduction/data/model/get_store_details_model.dart';
import 'package:shift7_app/features/introduction/presentation/cubit/intro_cubit.dart';
import 'package:shimmer/shimmer.dart';

class CustomMainAdWidget extends StatefulWidget {
  const CustomMainAdWidget({super.key});

  @override
  State<CustomMainAdWidget> createState() => _CustomMainAdWidgetState();
}

class _CustomMainAdWidgetState extends State<CustomMainAdWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IntroCubit, IntroState>(
      builder: (context, state) {
        switch (state.storeStatus) {
          case ApiStatus.loading:
            return const _LoadingAd();
          case ApiStatus.success:
            return _SuccessAd(stores: state.storeDetails!.store);
          case ApiStatus.error:
            return const SizedBox.shrink();
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}

class _LoadingAd extends StatelessWidget {
  const _LoadingAd();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: AspectRatio(
        aspectRatio: 375.w / 80.h,
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Container(color: Colors.grey[300]),
          ),
        ),
      ),
    );
  }
}

class _SuccessAd extends StatelessWidget {
  final StoreItemData stores;
  const _SuccessAd({required this.stores});

  @override
  Widget build(BuildContext context) {
    if (stores.media.isEmpty) return const SizedBox.shrink();
    final banners = stores.media.where((m) => m.name == 'main_banner_image');
    if (banners.isEmpty) return const SizedBox.shrink();
    final banner = banners.first;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutesKeys.mediaLinksDetails,
            arguments: {
              'mediaId': banner.mediaLinks.id,
              'mediaName': "ourProducts".tr(),
            },
          );
        },
        child: AspectRatio(
          aspectRatio: 375.w / 80.h,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.r),
            child: CachedNetworkImage(
              imageUrl: banner.url,
              fadeInDuration: const Duration(milliseconds: 300),
              fit: BoxFit.fitWidth,
              placeholder:
                  (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Container(color: Colors.grey[300]),
                    ),
                  ),
              errorWidget: (context, url, error) => const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}
