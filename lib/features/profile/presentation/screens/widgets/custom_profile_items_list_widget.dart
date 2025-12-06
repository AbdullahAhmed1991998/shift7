import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shift7_app/core/network/api_keys.dart';
import 'package:shift7_app/core/network/api_service.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/core/services/cache_helper_keys.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/features/app/presentation/cubit/app_cubit.dart';
import 'package:shift7_app/features/profile/data/models/profile_item_model.dart';
import 'package:shift7_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:shift7_app/features/profile/presentation/screens/widgets/custom_delete_account_dialog_widget.dart';
import 'package:shift7_app/features/profile/presentation/screens/widgets/custom_logout_dialog_widget.dart';
import 'package:shift7_app/features/profile/presentation/screens/widgets/custom_profile_item_widget.dart';

class CustomProfileItemsListWidget extends StatefulWidget {
  const CustomProfileItemsListWidget({super.key});

  @override
  State<CustomProfileItemsListWidget> createState() =>
      _CustomProfileItemsListWidgetState();
}

class _CustomProfileItemsListWidgetState
    extends State<CustomProfileItemsListWidget> {
  bool isLoggedIn = false;
  bool isLoading = true;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final token = await _secureStorage.read(key: userToken);
    if (!mounted) return;
    setState(() {
      isLoggedIn = token != null && token.isNotEmpty;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryColor,
          strokeWidth: 2.5,
        ),
      );
    }

    final items = buildProfileItems(context, isLoggedIn);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        children:
            items.map((item) {
              final isLogout = item.isLogout;
              final isDeleteAccount = item.isDeleteAccount;
              final isLogin = item.routeName == AppRoutesKeys.auth;

              return Padding(
                padding: EdgeInsets.only(bottom: 15.h),
                child: CustomProfileItemWidget(
                  iconPath: item.icon,
                  titleKey: item.title,
                  suffixType: item.suffixType,
                  isSwitchEnabled:
                      item.suffixType == 'switch'
                          ? context
                                  .watch<AppCubit>()
                                  .state
                                  .locale
                                  .languageCode ==
                              'ar'
                          : null,
                  onSwitchChanged:
                      item.suffixType == 'switch'
                          ? (value) {
                            final currentLang =
                                getIt<CacheHelper>().getData(key: 'language')
                                    as String?;
                            final isCurrentlyArabic = currentLang == 'ar';
                            final shouldBeArabic = !isCurrentlyArabic;

                            context.read<AppCubit>().changeLanguage(
                              shouldBeArabic,
                            );
                            context.setLocale(
                              shouldBeArabic
                                  ? const Locale('ar')
                                  : const Locale('en'),
                            );
                          }
                          : null,
                  onTap: () {
                    if (isDeleteAccount) {
                      _showDeleteAccountDialog(context);
                    } else if (isLogout) {
                      _showLogoutDialog(context);
                    } else if (isLogin) {
                      _navigateToLogin(context);
                    } else if (item.routeName != null) {
                      Navigator.pushNamed(context, item.routeName!);
                    }
                  },
                ),
              );
            }).toList(),
      ),
    );
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutesKeys.auth);
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black87,
      builder: (BuildContext dialogContext) {
        return CustomLogoutDialogWidget(
          onConfirm: () => _handleLogout(dialogContext),
        );
      },
    );
  }

  Future<void> _showDeleteAccountDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black87,
      builder: (BuildContext dialogContext) {
        return CustomDeleteAccountDialogWidget(
          onConfirm: () => _handleDeleteAccount(dialogContext),
        );
      },
    );
  }

  Future<void> _handleLogout(BuildContext dialogContext) async {
    await _performLogout();
    if (!dialogContext.mounted) return;
    Navigator.of(dialogContext).pop();
    if (!context.mounted) return;
    Navigator.of(
      // ignore: use_build_context_synchronously
      context,
    ).pushNamedAndRemoveUntil(AppRoutesKeys.initial, (route) => false);
  }

  Future<void> _handleDeleteAccount(BuildContext dialogContext) async {
    final profileCubit = context.read<ProfileCubit>();
    await profileCubit.deleteAccount();
    final state = profileCubit.state;

    if (state.deleteAccountStatus == ApiStatus.success) {
      await _performLogout();
      if (!dialogContext.mounted) return;
      Navigator.of(dialogContext).pop();
      if (!context.mounted) return;
      Navigator.of(
        // ignore: use_build_context_synchronously
        context,
      ).pushNamedAndRemoveUntil(AppRoutesKeys.initial, (route) => false);
    } else if (state.deleteAccountStatus == ApiStatus.error) {
      if (!dialogContext.mounted) return;
      ScaffoldMessenger.of(
        dialogContext,
      ).showSnackBar(SnackBar(content: Text(state.deleteAccountErrorMessage)));
    }
  }

  Future<void> _performLogout() async {
    try {
      await getIt<ApiService>().clearToken();
      await getIt<CacheHelper>().deleteItem(key: CacheHelperKeys.isLogin);
      await _secureStorage.delete(key: userToken);
      if (!mounted) return;
      setState(() {
        isLoggedIn = false;
      });
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }
}
