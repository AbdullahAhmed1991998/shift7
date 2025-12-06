import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/functions/reverse_geocoding_service.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_bottom.dart';
import 'package:shift7_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:shift7_app/features/cart/data/models/address_model.dart';
import 'package:shift7_app/features/cart/presentation/screens/widgets/custom_address_list_item.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomCurrentLocationWidget extends StatefulWidget {
  final ValueChanged<int>? onSelectedAddressId;
  const CustomCurrentLocationWidget({super.key, this.onSelectedAddressId});

  @override
  State<CustomCurrentLocationWidget> createState() =>
      _CustomCurrentLocationWidgetState();
}

class _CustomCurrentLocationWidgetState
    extends State<CustomCurrentLocationWidget> {
  int? _selectedIndex;
  final Map<int, Future<ResolvedAddress>> _futures = {};

  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().getAddressList();
  }

  String _localeId(BuildContext context) {
    final lang = context.locale.languageCode;
    final country = context.locale.countryCode ?? (lang == 'ar' ? 'EG' : 'US');
    return '${lang}_$country';
  }

  Future<ResolvedAddress> _resolve(AddressModel a) {
    final id = a.id;
    final existing = _futures[id];
    if (existing != null) return existing;

    final lat = a.latitude;
    final lng = a.longitude;

    final future = ReverseGeocodingService.instance.resolve(
      addressId: id,
      lat: lat ?? 0.0,
      lng: lng ?? 0.0,
      localeIdentifier: _localeId(context),
      fallbackLine1: a.addressLine1,
      fallbackCity: a.city,
      fallbackCountry: a.country,
    );

    _futures[id] = future;
    return future;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      buildWhen:
          (prev, curr) =>
              prev.getAddressListStatus != curr.getAddressListStatus ||
              prev.getAddressListModel != curr.getAddressListModel,
      builder: (context, state) {
        final loading = state.getAddressListStatus == ApiStatus.loading;
        final error = state.getAddressListStatus == ApiStatus.error;
        final addresses =
            state.getAddressListModel?.data ?? const <AddressModel>[];

        if (loading) {
          return _loadingSkeleton();
        }

        if (error) {
          return _errorBox(
            onRetry: () => context.read<CartCubit>().getAddressList(),
          );
        }

        if (addresses.isEmpty) {
          return _emptyBox();
        }

        if (_selectedIndex == null) {
          _selectedIndex = 0;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onSelectedAddressId?.call(addresses.first.id);
          });
        }

        return Column(
          children: List.generate(addresses.length, (index) {
            final a = addresses[index];

            return FutureBuilder<ResolvedAddress>(
              future: _resolve(a),
              builder: (context, snapshot) {
                final isSelected = _selectedIndex == index;
                final res = snapshot.data;

                final title =
                    (res?.title.isNotEmpty == true)
                        ? res!.title
                        : _pickBest([a.city, a.addressLine1, a.country]) ?? '—';

                final details =
                    (res?.details.isNotEmpty == true)
                        ? res!.details
                        : _join([
                          a.addressLine1,
                          a.addressLine2,
                          a.city,
                          a.country,
                        ]);

                return CustomAddressListItem(
                  title: title,
                  subtitle: details,
                  selected: isSelected,
                  onTap: () {
                    setState(() => _selectedIndex = index);
                    widget.onSelectedAddressId?.call(a.id);
                  },
                );
              },
            );
          }),
        );
      },
    );
  }

  Widget _loadingSkeleton() {
    return Column(
      children: List.generate(2, (i) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: Colors.white,
            border: Border.all(color: Colors.grey.withAlpha(20), width: 1.w),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(32),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.secondaryColor, AppColors.blackColor],
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmerLine(width: 160.w),
                    SizedBox(height: 6.h),
                    _shimmerLine(width: 220.w),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                width: 22.w,
                height: 22.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[300]!, width: 2.w),
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _shimmerLine({required double width}) {
    return Container(
      width: width,
      height: 12.h,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(6.r),
      ),
    );
  }

  Widget _errorBox({required VoidCallback onRetry}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.white,
        border: Border.all(color: Colors.red.withAlpha(40), width: 1.w),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 20.sp),
          SizedBox(width: 8.w),
          Expanded(child: Text('failedToLoadAddresses'.tr())),
          TextButton(onPressed: onRetry, child: Text('retry'.tr())),
        ],
      ),
    );
  }

  Widget _emptyBox() {
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
                  arguments: {'isCart': true},
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
}

String? _pickBest(List<String?> options) {
  for (final s in options) {
    if (s != null && s.trim().isNotEmpty) return s.trim();
  }
  return null;
}

String _join(List<String?> options) => options
    .where((e) => e != null && e.trim().isNotEmpty)
    .cast<String>()
    .join(', ');
