import 'package:easy_localization/easy_localization.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/features/app/data/models/bottom_navigation_item_model.dart';
import 'package:shift7_app/features/cart/presentation/screens/cart_screen.dart';
import 'package:shift7_app/features/categories/presentation/screens/categories_screen.dart';
import 'package:shift7_app/features/favorite/presentation/screens/favorite_screen.dart';
import 'package:shift7_app/features/home/presentation/screens/home_screen.dart';
import 'package:shift7_app/features/app/presentation/screens/widgets/custom_shift_7_app_bar_widget.dart';
import 'package:shift7_app/features/introduction/presentation/cubit/intro_cubit.dart';
import 'package:shift7_app/features/profile/presentation/screens/profile_screen.dart';

class Shift7MainApp extends StatefulWidget {
  final int storeId;
  const Shift7MainApp({super.key, required this.storeId});

  @override
  State<Shift7MainApp> createState() => _Shift7MainAppState();
}

class _Shift7MainAppState extends State<Shift7MainApp> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CategoriesScreen(),
    const FavoriteScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  initState() {
    super.initState();
    context.read<IntroCubit>().getStoresDetails(storeId: widget.storeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            if (_currentIndex == 0 ||
                _currentIndex == 1 ||
                _currentIndex == 2 ||
                _currentIndex == 4) ...[
              const CustomShift7AppBarWidget(),
            ],
            Expanded(child: _screens[_currentIndex]),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    final bottomNavItems = [
      BottomNavigationItemModel(label: 'home'.tr(), icon: EvaIcons.home),
      BottomNavigationItemModel(label: 'categories'.tr(), icon: EvaIcons.grid),
      BottomNavigationItemModel(label: 'favorites'.tr(), icon: EvaIcons.heart),
      BottomNavigationItemModel(
        label: 'cart'.tr(),
        icon: EvaIcons.shoppingCart,
      ),
      BottomNavigationItemModel(
        label: 'settings'.tr(),
        icon: EvaIcons.settings,
      ),
    ];

    return Container(
      key: Key('bottom_nav_${context.locale}'),
      height: 80.h,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 10.r,
            spreadRadius: 2.r,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 5.h),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppColors.secondaryColor,
          unselectedItemColor: Colors.grey[300],
          selectedLabelStyle: AppTextStyle.styleSecondary12W500,
          unselectedLabelStyle: AppTextStyle.styleBlack12W500.copyWith(
            color: Colors.grey[300],
          ),
          iconSize: 25.sp,
          items:
              bottomNavItems.map((item) {
                return BottomNavigationBarItem(
                  icon: Icon(item.icon, color: Colors.grey[300], size: 25.sp),
                  activeIcon: Icon(
                    item.icon,
                    color: AppColors.secondaryColor,
                    size: 25.sp,
                  ),
                  label: item.label,
                );
              }).toList(),
        ),
      ),
    );
  }
}
