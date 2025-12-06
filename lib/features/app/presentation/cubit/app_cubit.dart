import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/features/app/presentation/cubit/app_state.dart';
import 'package:easy_localization/easy_localization.dart';

class AppCubit extends Cubit<AppState> {
  final CacheHelper _cacheHelper;

  AppCubit({CacheHelper? cacheHelper})
    : _cacheHelper = cacheHelper ?? getIt<CacheHelper>(),
      super(const AppInitial(locale: Locale('ar'))) {
    _initialize();
  }

  Future<void> _initialize() async {
    await _cacheHelper.cacheInit();
    final savedLocaleCode = _cacheHelper.getData(key: 'language') as String?;
    if (savedLocaleCode == null) {
      await _cacheHelper.setData(key: 'language', value: 'ar');
      emit(state.copyWith(locale: const Locale('ar')));
    } else {
      emit(state.copyWith(locale: Locale(savedLocaleCode)));
    }
  }

  Future<void> changeLanguage(bool isArabic) async {
    final locale = isArabic ? const Locale('ar') : const Locale('en');
    await _cacheHelper.setData(key: 'language', value: locale.languageCode);
    emit(state.copyWith(locale: locale));
  }

  bool get isArabic => state.locale.languageCode == 'ar';

  Future<void> resetToDeviceLanguage(BuildContext context) async {
    await context.resetLocale();
    // ignore: use_build_context_synchronously
    final deviceLocale = context.deviceLocale;
    await _cacheHelper.setData(
      key: 'language',
      value: deviceLocale.languageCode,
    );
    emit(state.copyWith(locale: deviceLocale));
  }
}
