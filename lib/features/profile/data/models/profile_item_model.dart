import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileItemModel {
  final IconData icon;
  final String title;
  final String suffixType;
  final String? routeName;
  final bool isLogout;
  final bool isDeleteAccount;

  ProfileItemModel({
    required this.icon,
    required this.title,
    required this.suffixType,
    this.routeName,
    this.isLogout = false,
    this.isDeleteAccount = false,
  });
}

List<ProfileItemModel> buildProfileItems(
  BuildContext context,
  bool isLoggedIn,
) {
  List<ProfileItemModel> items = [
    ProfileItemModel(
      icon: EvaIcons.globe,
      title: 'arabicLanguage'.tr(),
      suffixType: 'switch',
    ),
  ];

  if (isLoggedIn) {
    items.addAll([
      ProfileItemModel(
        icon: EvaIcons.person,
        title: 'editProfile'.tr(),
        suffixType: 'arrow',
        routeName: AppRoutesKeys.editProfile,
      ),
      ProfileItemModel(
        icon: FontAwesomeIcons.locationArrow,
        title: 'yourLocations'.tr(),
        suffixType: 'arrow',
        routeName: AppRoutesKeys.setLocations,
      ),
      ProfileItemModel(
        icon: FontAwesomeIcons.box,
        title: 'myOrders'.tr(),
        suffixType: 'arrow',
        routeName: AppRoutesKeys.myOrders,
      ),
      ProfileItemModel(
        icon: EvaIcons.bell,
        title: 'notifications'.tr(),
        suffixType: 'arrow',
        routeName: AppRoutesKeys.notifications,
      ),
      ProfileItemModel(
        icon: EvaIcons.lock,
        title: 'privacyPolicy'.tr(),
        suffixType: 'arrow',
        routeName: AppRoutesKeys.privacyPolicy,
      ),
      ProfileItemModel(
        icon: EvaIcons.questionMarkCircle,
        title: 'helpCenter'.tr(),
        suffixType: 'arrow',
        routeName: AppRoutesKeys.helpCenter,
      ),
      ProfileItemModel(
        icon: EvaIcons.personDelete,
        title: 'deleteAccount'.tr(),
        suffixType: 'arrow',
        isDeleteAccount: true,
      ),
      ProfileItemModel(
        icon: Icons.logout,
        title: 'logout'.tr(),
        suffixType: 'arrow',
        isLogout: true,
      ),
    ]);
  } else {
    items.addAll([
      ProfileItemModel(
        icon: EvaIcons.lock,
        title: 'privacyPolicy'.tr(),
        suffixType: 'arrow',
        routeName: AppRoutesKeys.privacyPolicy,
      ),
      ProfileItemModel(
        icon: EvaIcons.questionMarkCircle,
        title: 'helpCenter'.tr(),
        suffixType: 'arrow',
        routeName: AppRoutesKeys.helpCenter,
      ),
      ProfileItemModel(
        icon: Icons.login_outlined,
        title: 'login'.tr(),
        suffixType: 'arrow',
        routeName: AppRoutesKeys.auth,
      ),
    ]);
  }

  return items;
}
