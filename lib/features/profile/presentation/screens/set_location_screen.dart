import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shift7_app/core/functions/show_toast.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/core/network/api_keys.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_bar.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_bottom.dart';
import 'package:shift7_app/core/utils/widgets/not_logged_in_widget.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_home_error_widget.dart';
import 'package:shift7_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:shift7_app/features/profile/presentation/screens/widgets/custom_location_loading_skeleton_widget.dart';
import 'package:shift7_app/features/profile/presentation/screens/widgets/custom_location_item_widget.dart';
import 'package:shift7_app/features/profile/data/models/get_user_address_model.dart';
import 'package:easy_localization/easy_localization.dart';

class SetLocationScreen extends StatefulWidget {
  const SetLocationScreen({super.key});

  @override
  State<SetLocationScreen> createState() => _SetLocationScreenState();
}

class _SetLocationScreenState extends State<SetLocationScreen> {
  final Set<int> _hiddenIds = <int>{};
  final Set<int> _deletingIds = <int>{};
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkTokenAndFetch();
  }

  Future<void> _checkTokenAndFetch() async {
    final token = await _secureStorage.read(key: userToken);
    _isLoggedIn = token != null && token.isNotEmpty;
    if (_isLoggedIn) {
      // ignore: use_build_context_synchronously
      await context.read<ProfileCubit>().getUserLocations();
    }
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  Future<void> _handleDelete(AddressModel address) async {
    final id = address.id as int?;
    if (id == null) return;
    setState(() {
      _deletingIds.add(id);
      _hiddenIds.add(id);
    });
    await context.read<ProfileCubit>().deleteLocation(addressId: id);
    // ignore: use_build_context_synchronously
    final state = context.read<ProfileCubit>().state;
    if (state.deleteLocationStatus == ApiStatus.error) {
      setState(() {
        _hiddenIds.remove(id);
        _deletingIds.remove(id);
      });
      final rawMsg = state.deleteLocationErrorMessage;
      final msg =
          (rawMsg.toString().trim().isNotEmpty)
              ? rawMsg
              : 'addressDeleteErrorGeneric'.tr();
      // ignore: use_build_context_synchronously
      showToast(context, isSuccess: false, message: msg, icon: Icons.error);
    } else if (state.deleteLocationStatus == ApiStatus.success) {
      setState(() {
        _deletingIds.remove(id);
      });
      showToast(
        // ignore: use_build_context_synchronously
        context,
        isSuccess: true,
        message: 'addressDeleteSuccess'.tr(),
        icon: Icons.check,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.h),
          child: CustomAppBar(
            title: 'yourLocations'.tr(),
            onBackPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryColor,
            strokeWidth: 2,
          ),
        ),
      );
    }

    if (!_isLoggedIn) {
      return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.h),
          child: CustomAppBar(
            title: 'yourLocations'.tr(),
            onBackPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: NotLoggedInWidget(resourceName: 'yourLocations'.tr()),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.h),
        child: CustomAppBar(
          title: 'yourLocations'.tr(),
          onBackPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.addressesStatus == ApiStatus.loading) {
            return const CustomLocationLoadingSkeletonWidget();
          }

          if (state.addressesStatus == ApiStatus.error) {
            return Center(
              child: CustomHomeErrorWidget(
                hasRetry: true,
                onRetry: () => context.read<ProfileCubit>().getUserLocations(),
              ),
            );
          }

          if (state.addressesStatus == ApiStatus.success) {
            final raw = state.addresses?.data ?? [];
            final visible =
                raw
                    .where((a) => !_hiddenIds.contains(a.id as int? ?? -1))
                    .toList();

            if (visible.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_off_outlined,
                        size: 56.sp,
                        color: Colors.grey.shade500,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'noSavedAddresses'.tr(),
                        style: AppTextStyle.styleBlack14W500,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 15.h),
                      CustomAppBottom(
                        backgroundColor: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(12.r),
                        height: 50.h,
                        horizontalPadding: 20.w,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutesKeys.addLocation,
                            arguments: {'isCart': false},
                          );
                        },
                        verticalPadding: 5.h,
                        width: double.infinity,
                        child: Text(
                          'addLocation'.tr(),
                          style: AppTextStyle.styleBlack16Bold.copyWith(
                            color: AppColors.whiteColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                    itemCount: visible.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final address = visible[index];
                      final id = address.id as int?;
                      final isDeleting =
                          id != null && _deletingIds.contains(id);
                      return AnimatedOpacity(
                        duration: const Duration(milliseconds: 180),
                        opacity: isDeleting ? 0.6 : 1.0,
                        child: CustomLocationItemWidget(
                          address: address,
                          onDelete: () => _handleDelete(address),
                          deleting: isDeleting,
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                  child: CustomAppBottom(
                    backgroundColor: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(12.r),
                    height: 50.h,
                    horizontalPadding: 20.w,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutesKeys.addLocation,
                        arguments: {'isCart': false},
                      );
                    },
                    verticalPadding: 5.h,
                    width: double.infinity,
                    child: Text(
                      'addLocation'.tr(),
                      style: AppTextStyle.styleBlack16Bold.copyWith(
                        color: AppColors.whiteColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
