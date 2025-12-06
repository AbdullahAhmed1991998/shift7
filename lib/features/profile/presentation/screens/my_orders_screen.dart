import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shift7_app/core/network/api_keys.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_bar.dart';
import 'package:shift7_app/core/utils/widgets/not_logged_in_widget.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_empty_widget.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_home_error_widget.dart';
import 'package:shift7_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:shift7_app/features/profile/presentation/screens/widgets/custom_my_orders_card_widget.dart';
import 'package:shift7_app/features/profile/presentation/screens/widgets/custom_my_orders_shimmer_list_widget.dart';
import 'package:shift7_app/features/profile/presentation/screens/widgets/custom_my_orders_shimmer_card_widget.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
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
        cubit.initMyOrders();
        _scrollController.addListener(_onScroll);
      });
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final cubit = context.read<ProfileCubit>();
    final s = cubit.state;
    if (s.ordersStatus != ApiStatus.success ||
        !s.ordersHasMore ||
        s.ordersLoadingMore) {
      return;
    }
    final pos = _scrollController.position;
    if (pos.maxScrollExtent <= 0) {
      cubit.loadMoreMyOrders();
      return;
    }
    final reached = pos.pixels / pos.maxScrollExtent >= 0.75;
    if (reached) {
      cubit.loadMoreMyOrders();
    }
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
            title: 'myOrders'.tr(),
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
            title: 'myOrders'.tr(),
            onBackPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(child: NotLoggedInWidget(resourceName: 'myOrders'.tr())),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.h),
        child: CustomAppBar(
          title: 'myOrders'.tr(),
          onBackPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        buildWhen:
            (p, c) =>
                p.ordersStatus != c.ordersStatus ||
                p.orderItems != c.orderItems ||
                p.ordersLoadingMore != c.ordersLoadingMore,
        builder: (context, state) {
          if (state.ordersStatus == ApiStatus.loading &&
              state.orderItems.isEmpty) {
            return const MyOrdersShimmerList();
          }

          if (state.ordersStatus == ApiStatus.error &&
              state.orderItems.isEmpty) {
            return Center(
              child: CustomHomeErrorWidget(
                hasRetry: true,
                onRetry: () => context.read<ProfileCubit>().initMyOrders(),
              ),
            );
          }

          if (state.ordersStatus == ApiStatus.success &&
              state.orderItems.isEmpty) {
            return Center(
              child: CustomEmptyWidget(message: 'noOrdersYet'.tr()),
            );
          }

          final items = state.orderItems;

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                sliver: SliverList.separated(
                  itemCount: items.length + (state.ordersLoadingMore ? 2 : 0),
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    if (index >= items.length) {
                      return const MyOrdersShimmerCard();
                    }

                    final order = items[index];

                    return MyOrdersCard(order: order, onTap: () {});
                  },
                ),
              ),
              if (state.ordersLoadingMore)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
