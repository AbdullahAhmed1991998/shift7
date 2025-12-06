import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shift7_app/core/network/api_keys.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/widgets/not_logged_in_widget.dart';
import 'package:shift7_app/features/favorite/presentation/cubit/fav_cubit.dart';
import 'package:shift7_app/features/favorite/presentation/screens/widgets/custom_favorite_card_widget.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_home_error_widget.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_empty_widget.dart';

class CustomFavoriteListView extends StatefulWidget {
  const CustomFavoriteListView({super.key});

  @override
  State<CustomFavoriteListView> createState() => _CustomFavoriteListViewState();
}

class _CustomFavoriteListViewState extends State<CustomFavoriteListView> {
  bool isLoggedIn = false;
  bool isLoading = true;
  bool hasLoadedOnce = false;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    checkTokenAndFetch();
  }

  Future<void> checkTokenAndFetch() async {
    if (mounted) {
      setState(() {
        isLoading = true;
        hasLoadedOnce = false;
      });
    }

    final token = await _secureStorage.read(key: userToken);
    isLoggedIn = token != null && token.isNotEmpty;

    if (isLoggedIn && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final cubit = context.read<FavCubit>();
        cubit.initFavList();
        _scrollController.addListener(_onScroll);
      });
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final cubit = context.read<FavCubit>();
    final s = cubit.state;
    if (s.favStatus != ApiStatus.success || !s.favHasMore || s.favLoadingMore) {
      return;
    }
    final pos = _scrollController.position;
    if (pos.maxScrollExtent <= 0) {
      cubit.loadMoreFavList();
      return;
    }
    final reached = pos.pixels / pos.maxScrollExtent >= 0.75;
    if (reached) {
      cubit.loadMoreFavList();
    }
  }

  void removeItem(int index, int productId) {
    final cubit = context.read<FavCubit>();
    final currentItems = List.from(cubit.state.favItems);
    currentItems.removeAt(index);
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    cubit.emit(cubit.state.copyWith(favItems: currentItems));
    cubit.setFav(productId: productId);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryColor),
      );
    }

    if (!isLoggedIn) {
      return Center(
        child: NotLoggedInWidget(resourceName: "favoritesTitle".tr()),
      );
    }

    return BlocConsumer<FavCubit, FavState>(
      listener: (context, state) {
        if ((state.favStatus == ApiStatus.success ||
                state.favStatus == ApiStatus.error) &&
            !hasLoadedOnce &&
            mounted) {
          setState(() {
            hasLoadedOnce = true;
          });
        }
      },
      builder: (context, state) {
        if (!hasLoadedOnce && state.favStatus != ApiStatus.error) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        if (state.favStatus == ApiStatus.error) {
          return Center(
            child: CustomHomeErrorWidget(onRetry: () => checkTokenAndFetch()),
          );
        }

        final favItems = state.favItems;

        if (favItems.isEmpty && hasLoadedOnce) {
          return Center(child: CustomEmptyWidget(message: "noFavorites".tr()));
        }

        return CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (state.favLoadingMore && index >= favItems.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (index >= favItems.length) return null;
                    final item = favItems[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: GestureDetector(
                        onTap:
                            () => Navigator.pushNamed(
                              context,
                              AppRoutesKeys.product,
                              arguments: {"productId": item.id},
                            ),
                        child: CustomFavoriteCardWidget(
                          product: item,
                          onDelete: () => removeItem(index, item.id),
                        ),
                      ),
                    );
                  },
                  childCount: favItems.length + (state.favLoadingMore ? 1 : 0),
                ),
              ),
            ),
            if (state.favLoadingMore)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        );
      },
    );
  }
}
