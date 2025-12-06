import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shift7_app/core/network/api_keys.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_bar.dart';
import 'package:shift7_app/core/utils/widgets/not_logged_in_widget.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_home_error_widget.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_empty_widget.dart';
import 'package:shift7_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:shift7_app/features/profile/presentation/screens/widgets/custom_notification_card_widget.dart';
import 'package:shift7_app/features/profile/presentation/screens/widgets/custom_notifications_loading_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final ScrollController _scrollController = ScrollController();
  bool _authChecked = false;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkAuthAndFetch());
  }

  Future<void> _checkAuthAndFetch() async {
    final token = await _secureStorage.read(key: userToken);
    final logged = token != null && token.isNotEmpty;
    if (!mounted) return;
    setState(() {
      _isLoggedIn = logged;
      _authChecked = true;
    });
    if (logged && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final cubit = context.read<ProfileCubit>();
        cubit.initAllNotifications();
        _scrollController.addListener(_onScroll);
      });
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final cubit = context.read<ProfileCubit>();
    final s = cubit.state;
    if (s.notificationsStatus != ApiStatus.success ||
        !s.notificationsHasMore ||
        s.notificationsLoadingMore) {
      return;
    }
    final pos = _scrollController.position;
    if (pos.maxScrollExtent <= 0) {
      cubit.loadMoreNotifications();
      return;
    }
    final reached = pos.pixels / pos.maxScrollExtent >= 0.75;
    if (reached) {
      cubit.loadMoreNotifications();
    }
  }

  Future<void> _onRefresh() async {
    await context.read<ProfileCubit>().initAllNotifications();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_authChecked) {
      return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.h),
          child: CustomAppBar(
            title: 'notifications'.tr(),
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
            title: 'notifications'.tr(),
            onBackPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: NotLoggedInWidget(resourceName: 'notifications'.tr()),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.h),
        child: CustomAppBar(
          title: 'notifications'.tr(),
          onBackPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        buildWhen:
            (p, c) =>
                p.notificationsStatus != c.notificationsStatus ||
                p.notificationItems != c.notificationItems ||
                p.notificationsLoadingMore != c.notificationsLoadingMore,
        builder: (context, state) {
          if (state.notificationsStatus == ApiStatus.loading) {
            return const CustomNotificationsLoadingWidget();
          }

          if (state.notificationsStatus == ApiStatus.error) {
            return Center(
              child: CustomHomeErrorWidget(
                hasRetry: true,
                onRetry:
                    () => context.read<ProfileCubit>().initAllNotifications(),
              ),
            );
          }

          if (state.notificationsStatus == ApiStatus.success) {
            final items = state.notificationItems;
            if (items.isEmpty) {
              return Center(
                child: CustomEmptyWidget(message: 'noNotificationsYet'.tr()),
              );
            }

            return RefreshIndicator(
              color: AppColors.primaryColor,
              onRefresh: _onRefresh,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    sliver: SliverList.separated(
                      itemCount:
                          items.length +
                          (state.notificationsLoadingMore ? 2 : 0),
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        if (index >= items.length) {
                          return const _NotificationsLoadingItem();
                        }
                        final item = items[index];
                        return CustomNotificationCardWidget(item: item);
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _NotificationsLoadingItem extends StatelessWidget {
  const _NotificationsLoadingItem();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Container(
        height: 72.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Colors.grey[200],
        ),
      ),
    );
  }
}
