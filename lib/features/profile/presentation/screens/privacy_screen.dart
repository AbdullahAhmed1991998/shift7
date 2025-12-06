import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_bar.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_bottom.dart';
import 'package:shift7_app/features/home/presentation/screens/widgets/custom_home_error_widget.dart';
import 'package:shift7_app/features/profile/presentation/cubit/profile_cubit.dart';

import '../../../../core/services/service_locator.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  @override
  void initState() {
    super.initState();
    // ignore: use_build_context_synchronously
    Future.microtask(() => context.read<ProfileCubit>().getPrivacyAndPolicy());
  }

  @override
  Widget build(BuildContext context) {
    final isArabicApp = getIt<CacheHelper>().getData(key: 'language') == 'ar';
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.h),
        child: CustomAppBar(
          title: "privacyPolicyTitle".tr(),
          onBackPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        buildWhen:
            (prev, curr) =>
                prev.privacyStatus != curr.privacyStatus ||
                prev.privacyData != curr.privacyData,
        builder: (context, state) {
          if (state.privacyStatus == ApiStatus.loading) {
            return Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: AppColors.secondaryColor,
                size: 36.sp,
              ),
            );
          }

          if (state.privacyStatus == ApiStatus.error) {
            return Center(
              child: CustomHomeErrorWidget(
                hasRetry: true,
                onRetry:
                    () => context.read<ProfileCubit>().getPrivacyAndPolicy(),
              ),
            );
          }

          final dataList = state.privacyData?.data;
          final selection =
              (dataList == null || dataList.isEmpty)
                  ? null
                  : _pickHtmlByKey(dataList);

          if (selection == null || selection.html.trim().isEmpty) {
            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.privacy_tip_outlined,
                            size: 48.sp,
                            color: AppColors.secondaryColor,
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            "noPrivacyItems".tr(),
                            textAlign: TextAlign.center,
                            style: AppTextStyle.styleBlack14W500.copyWith(
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 12.h),
                          CustomAppBottom(
                            backgroundColor: AppColors.secondaryColor,
                            borderRadius: BorderRadius.circular(12.r),
                            height: 50.h,
                            horizontalPadding: 20.w,
                            verticalPadding: 5.h,
                            width: double.infinity,
                            onTap:
                                () =>
                                    context
                                        .read<ProfileCubit>()
                                        .getPrivacyAndPolicy(),
                            child: Text(
                              "reload".tr(),
                              style: AppTextStyle.styleBlack14W500.copyWith(
                                color: AppColors.whiteColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          final sections = _parseSections(selection.html);

          final children = <Widget>[];
          children.add(
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
              child: Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor.withAlpha(24),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.privacy_tip,
                      color: AppColors.secondaryColor,
                      size: 24.sp,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        "privacyNotice".tr(),
                        textAlign:
                            isArabicApp ? TextAlign.right : TextAlign.left,
                        style: AppTextStyle.styleBlack14W500.copyWith(
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );

          int counter = 1;
          for (final s in sections) {
            if (s.title.trim().isNotEmpty) {
              children.add(SizedBox(height: 16.h));
              children.add(
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withAlpha(10),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: AppColors.primaryColor.withAlpha(40),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.folder_special_rounded,
                          size: 18.sp,
                          color: AppColors.primaryColor,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            s.title,
                            textAlign:
                                isArabicApp ? TextAlign.right : TextAlign.left,
                            style: AppTextStyle.styleBlack14W500.copyWith(
                              fontSize: 16.sp,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            for (final it in s.items) {
              children.add(SizedBox(height: 10.h));
              children.add(
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: _NumberedItem(
                    number: counter++,
                    title: it.title,
                    description: it.description,
                    isArabic: isArabicApp,
                  ),
                ),
              );
            }
          }

          children.add(const SizedBox(height: 8));

          return Scrollbar(
            radius: Radius.circular(12.r),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                SliverList(delegate: SliverChildListDelegate(children)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PickedHtml {
  final String html;
  final bool isArabic;
  final String key;
  const _PickedHtml({
    required this.html,
    required this.isArabic,
    required this.key,
  });
}

_PickedHtml? _pickHtmlByKey(List<dynamic> dataList) {
  MapEntry<String, String>? findExact(String k) {
    try {
      final e = dataList.firstWhere(
        (x) => (x.key ?? '').toString().trim().toLowerCase() == k,
      );
      final v = (e.value as String?)?.trim();
      if (v != null && v.isNotEmpty) {
        return MapEntry((e.key as String).trim(), v);
      }
    } catch (_) {}
    return null;
  }

  MapEntry<String, String>? endsWithLang(String suffix) {
    try {
      final e = dataList.firstWhere(
        (x) => (x.key ?? '').toString().trim().toLowerCase().endsWith(suffix),
      );
      final v = (e.value as String?)?.trim();
      if (v != null && v.isNotEmpty) {
        return MapEntry((e.key as String).trim(), v);
      }
    } catch (_) {}
    return null;
  }

  MapEntry<String, String>? pick =
      findExact('privacy_policy_ar') ??
      endsWithLang('_ar') ??
      findExact('privacy_policy_en') ??
      endsWithLang('_en');

  if (pick == null) {
    for (final e in dataList) {
      final v = (e.value as String?)?.trim();
      final k = (e.key as String?)?.trim() ?? '';
      if (v != null && v.isNotEmpty) {
        pick = MapEntry(k, v);
        break;
      }
    }
  }

  if (pick == null) return null;

  final keyLower = pick.key.toLowerCase();
  final isArabicKey = keyLower.endsWith('ar');
  return _PickedHtml(html: pick.value, isArabic: isArabicKey, key: pick.key);
}

class _Section {
  final String title;
  final List<_Item> items;
  const _Section({required this.title, required this.items});
}

class _Item {
  final String title;
  final String description;
  const _Item({required this.title, required this.description});
}

List<_Section> _parseSections(String html) {
  final out = <_Section>[];
  final sectionRe = RegExp(
    r'<section[^>]*>(.*?)</section>',
    dotAll: true,
    caseSensitive: false,
  );
  final h1Re = RegExp(
    r'<h1[^>]*>(.*?)</h1>',
    dotAll: true,
    caseSensitive: false,
  );
  final h2Re = RegExp(
    r'<h2[^>]*>(.*?)</h2>',
    dotAll: true,
    caseSensitive: false,
  );
  final pRe = RegExp(r'<p[^>]*>(.*?)</p>', dotAll: true, caseSensitive: false);

  final sections =
      sectionRe.allMatches(html).map((m) => m.group(1) ?? '').toList();
  if (sections.isEmpty) sections.add(html);

  for (final s in sections) {
    String header = '';
    final h1 = h1Re.firstMatch(s);
    if (h1 != null) header = _stripTags(h1.group(1) ?? '').trim();

    final h2s = h2Re.allMatches(s).toList();
    final items = <_Item>[];

    if (h2s.isEmpty) {
      final ps =
          pRe
              .allMatches(s)
              .map((m) => _stripTags(m.group(1) ?? '').trim())
              .where((e) => e.isNotEmpty)
              .toList();
      if (ps.isNotEmpty) {
        items.add(
          _Item(
            title: header.isEmpty ? ' ' : header,
            description: ps.join('\n\n'),
          ),
        );
      }
      out.add(_Section(title: header.isEmpty ? '' : header, items: items));
      continue;
    }

    for (var i = 0; i < h2s.length; i++) {
      final h2 = h2s[i];
      final title = _stripTags(h2.group(1) ?? '').trim();
      final start = h2.end;
      final end = (i + 1 < h2s.length) ? h2s[i + 1].start : s.length;
      final block = s.substring(start, end);
      final ps =
          pRe
              .allMatches(block)
              .map((m) => _stripTags(m.group(1) ?? '').trim())
              .where((e) => e.isNotEmpty)
              .toList();
      final desc = ps.isNotEmpty ? ps.join('\n\n') : _stripTags(block).trim();
      items.add(_Item(title: title.isEmpty ? ' ' : title, description: desc));
    }

    out.add(_Section(title: header.isEmpty ? '' : header, items: items));
  }

  return out;
}

String _stripTags(String input) {
  var out = input.replaceAll(RegExp(r'<[^>]+>', dotAll: true), ' ');
  out = out
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>');
  out = out.replaceAll(RegExp(r'\s+'), ' ').trim();
  return out;
}

class _NumberedItem extends StatelessWidget {
  final int number;
  final String title;
  final String description;
  final bool isArabic;
  const _NumberedItem({
    required this.number,
    required this.title,
    required this.description,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NumberBadge(number: number),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.styleBlack14W500.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  description,
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  style: AppTextStyle.styleBlack14W500.copyWith(
                    color: Colors.grey[700],
                    height: 1.6,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NumberBadge extends StatelessWidget {
  final int number;
  const _NumberBadge({required this.number});

  @override
  Widget build(BuildContext context) {
    final n = number.toString();
    return Container(
      width: 34.w,
      height: 34.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor.withAlpha(230),
            AppColors.secondaryColor.withAlpha(230),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withAlpha(45),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        n,
        style: AppTextStyle.styleBlack14W500.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 14.sp,
        ),
      ),
    );
  }
}
