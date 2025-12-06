import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/cache_helper_keys.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_bottom.dart';
import 'package:shift7_app/features/app/presentation/screens/widgets/custom_store_image_widget.dart';
import 'package:shift7_app/features/introduction/data/model/get_store_details_model.dart';

class CustomStoreButtonWidget extends StatelessWidget {
  final StoreItemData store;
  final int index;

  const CustomStoreButtonWidget({
    super.key,
    required this.store,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        store.media
            .firstWhere(
              (m) => m.name == 'store_image',
              orElse:
                  () => StoreItemMediaModel(
                    id: 0,
                    name: '',
                    url: '',
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                    mediaLinks: MediaLinks(id: 0, mediaId: 0, type: 0),
                  ),
            )
            .url;

    return Padding(
      padding: EdgeInsets.only(left: 5.w, right: 5.w),
      child: Container(
        height: 50.h,
        width: 110.w,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: GestureDetector(
          onTap: () => _showStoreDialog(context, store),
          child: CustomStoreImageWidget(
            imageUrl: imageUrl,
            height: 50.h,
            width: 60.w,
            small: true,
          ),
        ),
      ),
    );
  }

  void _showStoreDialog(BuildContext context, StoreItemData store) {
    bool isLoading = false;
    bool isArabic = getIt<CacheHelper>().getData(key: 'language') == 'ar';
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Store Dialog',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder:
          (context, animation, secondaryAnimation) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, _) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );
        return ScaleTransition(
          scale: curved,
          child: FadeTransition(
            opacity: animation,
            child: Center(
              child: StatefulBuilder(
                builder: (context, setDialogState) {
                  return Material(
                    color: Colors.transparent,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 24.w),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 20.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withAlpha(20),
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsets.all(12.r),
                            child: Icon(
                              Icons.store_mall_directory_rounded,
                              color: AppColors.primaryColor,
                              size: 36.r,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'switch_store'.tr(),
                            style: AppTextStyle.styleBlack16Bold.copyWith(
                              fontSize: 18.sp,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            '${'do_you_want_to_go_to'.tr()}\n${isArabic ? store.nameAr : store.nameEn}',
                            style: AppTextStyle.styleBlack16Bold,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 24.h),
                          Row(
                            children: [
                              Expanded(
                                child: CustomAppBottom(
                                  backgroundColor: AppColors.greyColor,
                                  borderRadius: BorderRadius.circular(12.r),
                                  height: 45.h,
                                  onTap: () => Navigator.pop(context),
                                  child: Center(
                                    child: Text(
                                      'cancel'.tr(),
                                      style: AppTextStyle.styleBlack14W500
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: CustomAppBottom(
                                  backgroundColor: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(12.r),
                                  height: 45.h,
                                  onTap: () async {
                                    setDialogState(() => isLoading = true);
                                    await Future.delayed(
                                      const Duration(milliseconds: 300),
                                    );
                                    if (context.mounted) {
                                      getIt<CacheHelper>().setData(
                                        key: CacheHelperKeys.mainStoreId,
                                        value: store.id,
                                      );
                                      Navigator.pop(context);
                                      Navigator.pushReplacementNamed(
                                        context,
                                        AppRoutesKeys.shift7MainApp,
                                        arguments: {"storeId": store.id},
                                      );
                                    }
                                  },
                                  child: Center(
                                    child:
                                        isLoading
                                            ? SizedBox(
                                              height: 20.h,
                                              width: 20.h,
                                              child:
                                                  const CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                          Color
                                                        >(Colors.white),
                                                  ),
                                            )
                                            : Text(
                                              'go'.tr(),
                                              style: AppTextStyle
                                                  .styleBlack14W500
                                                  .copyWith(
                                                    color: Colors.white,
                                                  ),
                                            ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
