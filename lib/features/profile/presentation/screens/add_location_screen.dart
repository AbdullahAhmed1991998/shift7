import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shift7_app/core/functions/show_toast.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_bar.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_bottom.dart';
import 'package:shift7_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:shift7_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:shift7_app/features/profile/presentation/screens/widgets/custom_address_form_widget.dart';
import 'package:shift7_app/features/profile/presentation/screens/widgets/custom_map_card_widget.dart';
import 'package:shift7_app/features/profile/presentation/screens/widgets/custom_permission_dialog_widget.dart';

class AddLocationScreen extends StatefulWidget {
  final bool isCart;
  const AddLocationScreen({super.key, required this.isCart});

  @override
  State<AddLocationScreen> createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  GoogleMapController? _mapController;

  static const LatLng _jordanCenter = LatLng(31.2400, 36.5100);
  static const double _initialZoom = 10;
  static const double _focusZoom = 18.0;

  LatLng? _currentLatLng;
  Marker? _currentMarker;
  bool _isLoading = true;
  bool _locationGranted = false;

  final TextEditingController _streetCtrl = TextEditingController();
  final TextEditingController _areaCtrl = TextEditingController();
  final TextEditingController _governorateCtrl = TextEditingController();
  final TextEditingController _countryCtrl = TextEditingController();
  final TextEditingController _zipCtrl = TextEditingController();

  String? _autoStreet;
  String? _autoArea;
  String? _autoGovernorateLocalized;
  // ignore: unused_field
  String? _autoGovernorateEnglish;
  String? _autoCountry;
  String? _autoZip;

  static const List<Map<String, String>> _governorates = [
    {'arabic': 'عمان', 'english': 'Amman'},
    {'arabic': 'البلقاء', 'english': 'Balqa'},
    {'arabic': 'الزرقاء', 'english': 'Zarqa'},
    {'arabic': 'مادبا', 'english': 'Madaba'},
    {'arabic': 'إربد', 'english': 'Irbid'},
    {'arabic': 'جرش', 'english': 'Jerash'},
    {'arabic': 'عجلون', 'english': 'Ajloun'},
    {'arabic': 'المفرق', 'english': 'Mafraq'},
    {'arabic': 'الكرك', 'english': 'Karak'},
    {'arabic': 'الطفيلة', 'english': 'Tafila'},
    {'arabic': 'معان', 'english': "Ma'an"},
    {'arabic': 'العقبة', 'english': 'Aqaba'},
  ];

  List<String> get _governorateItems {
    final isArabic = context.locale.languageCode == 'ar';
    return _governorates
        .map((g) => isArabic ? g['arabic']! : g['english']!)
        .toList();
  }

  String _mapGovernorateToEnglish(String value) {
    if (value.isEmpty) {
      return '';
    }
    final match = _governorates.firstWhere(
      (g) => g['arabic'] == value || g['english'] == value,
      orElse: () => {'english': value},
    );
    return match['english'] ?? value;
  }

  String _normalizeDigitsToEnglish(String input) {
    const arabicIndic = '٠١٢٣٤٥٦٧٨٩';
    const easternIndic = '۰۱۲۳۴۵۶۷۸۹';
    final buffer = StringBuffer();
    for (final ch in input.split('')) {
      final i1 = arabicIndic.indexOf(ch);
      final i2 = easternIndic.indexOf(ch);
      if (i1 != -1) {
        buffer.write(i1.toString());
      } else if (i2 != -1) {
        buffer.write(i2.toString());
      } else {
        buffer.write(ch);
      }
    }
    return buffer.toString();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureLocationOnce());
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _streetCtrl.dispose();
    _areaCtrl.dispose();
    _governorateCtrl.dispose();
    _countryCtrl.dispose();
    _zipCtrl.dispose();
    super.dispose();
  }

  Future<void> _ensureLocationOnce() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      final go = await showDialog<bool>(
        // ignore: use_build_context_synchronously
        context: context,
        barrierDismissible: false,
        builder:
            (_) => CustomPermissionDialogWidget(
              title: "locationTurnOnTitle".tr(),
              message: "locationTurnOnMsg".tr(),
              positive: "openSettings".tr(),
              negative: "cancel".tr(),
              icon: Icons.gps_off_rounded,
            ),
      );
      if (go == true) await Geolocator.openLocationSettings();
    }

    var p = await Geolocator.checkPermission();
    if (p == LocationPermission.denied) {
      final ok = await showDialog<bool>(
        // ignore: use_build_context_synchronously
        context: context,
        barrierDismissible: false,
        builder:
            (_) => CustomPermissionDialogWidget(
              title: "allowLocationTitle".tr(),
              message: "allowLocationMsg".tr(),
              positive: "allow".tr(),
              negative: "cancel".tr(),
              icon: Icons.location_on_rounded,
            ),
      );
      if (ok == true) {
        p = await Geolocator.requestPermission();
      }
    }

    if (p == LocationPermission.deniedForever) {
      final go = await showDialog<bool>(
        // ignore: use_build_context_synchronously
        context: context,
        barrierDismissible: false,
        builder:
            (_) => CustomPermissionDialogWidget(
              title: "permissionRequiredTitle".tr(),
              message: "permissionRequiredMsg".tr(),
              positive: "openSettings".tr(),
              negative: "cancel".tr(),
              icon: Icons.lock_rounded,
            ),
      );
      if (go == true) await Geolocator.openAppSettings();
    }

    _locationGranted =
        p == LocationPermission.always || p == LocationPermission.whileInUse;

    if (_locationGranted) {
      try {
        final pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 100,
          ),
        );
        final latLng = LatLng(pos.latitude, pos.longitude);
        if (!mounted) return;
        setState(() {
          _currentLatLng = latLng;
          _currentMarker = const Marker(
            markerId: MarkerId('me'),
          ).copyWith(positionParam: latLng);
          _isLoading = false;
        });
        await _reverseGeocodeAndFill(latLng);
        if (_mapController != null) {
          await _mapController!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: latLng, zoom: _focusZoom),
            ),
          );
        }
        return;
      } catch (_) {}
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _recenterToCurrent() async {
    if (!_locationGranted) {
      await _ensureLocationOnce();
      if (!_locationGranted) return;
    }
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        ),
      );
      final latLng = LatLng(pos.latitude, pos.longitude);
      if (!mounted) return;
      setState(() {
        _currentLatLng = latLng;
        _currentMarker = const Marker(
          markerId: MarkerId('me'),
        ).copyWith(positionParam: latLng);
      });
      await _reverseGeocodeAndFill(latLng);
      await _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: latLng, zoom: _focusZoom),
        ),
      );
    } catch (_) {}
  }

  Future<void> _reverseGeocodeAndFill(LatLng ll) async {
    try {
      final isArabic = getIt<CacheHelper>().getData(key: 'language') == 'ar';
      final res = await placemarkFromCoordinates(ll.latitude, ll.longitude);
      if (res.isEmpty) return;
      final p = res.first;
      final rawStreet =
          (p.street?.trim().isNotEmpty == true ? p.street : null) ??
          (p.name?.trim().isNotEmpty == true ? p.name : '') ??
          '';
      final rawArea =
          (p.subLocality?.trim().isNotEmpty == true ? p.subLocality : null) ??
          (p.locality?.trim().isNotEmpty == true ? p.locality : '') ??
          '';
      final rawGovernorate =
          (p.administrativeArea?.trim().isNotEmpty == true
              ? p.administrativeArea
              : null) ??
          (p.subAdministrativeArea?.trim().isNotEmpty == true
              ? p.subAdministrativeArea
              : '') ??
          '';
      final rawCountry = p.country ?? '';
      final rawZip = p.postalCode ?? '';

      final street = _normalizeDigitsToEnglish(rawStreet);
      final area = _normalizeDigitsToEnglish(rawArea);
      final governorate = _normalizeDigitsToEnglish(rawGovernorate);
      final country = _normalizeDigitsToEnglish(rawCountry);
      final zip = _normalizeDigitsToEnglish(rawZip);

      final englishGov = _mapGovernorateToEnglish(governorate);
      Map<String, String>? govMatch;
      if (englishGov.isNotEmpty) {
        govMatch = _governorates.firstWhere(
          (g) => (g['english'] ?? '').toLowerCase() == englishGov.toLowerCase(),
          orElse: () => {},
        );
        if (govMatch.isEmpty) {
          govMatch = null;
        }
      }

      _autoStreet = street;
      _autoArea = area;
      _autoCountry = country;
      _autoZip = zip;
      if (govMatch != null) {
        _autoGovernorateEnglish = govMatch['english'];
        _autoGovernorateLocalized =
            isArabic ? govMatch['arabic'] : govMatch['english'];
      } else {
        _autoGovernorateEnglish = null;
        _autoGovernorateLocalized = null;
      }
    } catch (_) {}
  }

  void _applyAutoAddress() {
    final street = (_autoStreet ?? '').trim();
    final area = (_autoArea ?? '').trim();
    final gov = (_autoGovernorateLocalized ?? '').trim();
    final country = (_autoCountry ?? '').trim();
    final zip = (_autoZip ?? '').trim();

    if (street.isEmpty &&
        area.isEmpty &&
        gov.isEmpty &&
        country.isEmpty &&
        zip.isEmpty) {
      showToast(
        context,
        isSuccess: false,
        message: 'address_not_detected'.tr(),
        icon: Icons.error_outline,
      );
      return;
    }

    setState(() {
      _streetCtrl.text = street;
      _areaCtrl.text = area;
      _governorateCtrl.text = gov;
      _countryCtrl.text = country;
      _zipCtrl.text = zip;
    });
  }

  void _onSavePressed(BuildContext context) {
    if (_currentLatLng == null) return;
    final street = _normalizeDigitsToEnglish(_streetCtrl.text.trim());
    final area = _normalizeDigitsToEnglish(_areaCtrl.text.trim());
    final govText = _normalizeDigitsToEnglish(_governorateCtrl.text.trim());
    final country = _normalizeDigitsToEnglish(_countryCtrl.text.trim());
    final zip = _normalizeDigitsToEnglish(_zipCtrl.text.trim());
    final normalizedGov = _mapGovernorateToEnglish(govText);
    context.read<ProfileCubit>().setLocation(
      addressLine1: street.isEmpty ? '' : street,
      addressLine2: area.isEmpty ? '' : area,
      city: normalizedGov.isEmpty ? '' : normalizedGov,
      country: country.isEmpty ? '' : country,
      governorate: normalizedGov.isEmpty ? '' : normalizedGov,
      zipCode: zip.isEmpty ? '' : zip,
      long: _currentLatLng!.longitude.toString(),
      lat: _currentLatLng!.latitude.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listenWhen:
          (prev, curr) => prev.setLocationStatus != curr.setLocationStatus,
      listener: (context, state) {
        if (state.setLocationStatus == ApiStatus.success) {
          showToast(
            context,
            isSuccess: true,
            message: "yourAddressAddedSuccess".tr(),
            icon: Icons.check,
          );
        } else if (state.setLocationStatus == ApiStatus.error) {
          showToast(
            context,
            isSuccess: false,
            message: state.setLocationErrorMessage,
            icon: Icons.error_outline,
          );
        }
      },
      builder: (context, state) {
        final isSaving = state.setLocationStatus == ApiStatus.loading;

        return Scaffold(
          backgroundColor: AppColors.whiteColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(56.h),
            child: CustomAppBar(
              title: "addLocation".tr(),
              onBackPressed: () {
                Navigator.pop(context);
                widget.isCart
                    ? context.read<CartCubit>().getAddressList()
                    : context.read<ProfileCubit>().getUserLocations();
              },
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                CustomMapCardWidget(
                  isLoading: _isLoading,
                  locationGranted: _locationGranted,
                  initialTarget: _jordanCenter,
                  initialZoom: _initialZoom,
                  focusZoom: _focusZoom,
                  currentMarker: _currentMarker,
                  locateMeLabel: "locateMe".tr(),
                  onMapCreated: (c) async {
                    _mapController = c;
                    if (_currentLatLng != null) {
                      await _mapController!.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: _currentLatLng!,
                            zoom: _focusZoom,
                          ),
                        ),
                      );
                    }
                  },
                  onMapTap: (latLng) async {
                    setState(() {
                      _currentLatLng = latLng;
                      _currentMarker = const Marker(
                        markerId: MarkerId('picked_location'),
                      ).copyWith(positionParam: latLng);
                    });
                    await _reverseGeocodeAndFill(latLng);
                  },
                  onLocateMePressed: _recenterToCurrent,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: CustomAppBottom(
                    onTap: _applyAutoAddress,
                    backgroundColor: AppColors.primaryColor.withAlpha(46),
                    borderRadius: BorderRadius.circular(12.r),
                    height: 44.h,
                    width: double.infinity,
                    child: Text(
                      'fillAddressAutomatically'.tr(),
                      style: AppTextStyle.styleBlack16W500.copyWith(
                        color: AppColors.primaryColor,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 12.h),
                        CustomAddressFormWidget(
                          streetController: _streetCtrl,
                          areaController: _areaCtrl,
                          governorateController: _governorateCtrl,
                          countryController: _countryCtrl,
                          zipController: _zipCtrl,
                          streetHint: "street".tr(),
                          areaHint: "area".tr(),
                          governorateHint: "governorateSector".tr(),
                          countryHint: "country".tr(),
                          zipHint: "zipCode".tr(),
                          governorateItems: _governorateItems,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Container(
              padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
              color: Colors.white,
              child: SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed:
                      (_currentLatLng == null || isSaving)
                          ? null
                          : () => _onSavePressed(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child:
                      isSaving
                          ? Center(
                            child: LoadingAnimationWidget.staggeredDotsWave(
                              color: AppColors.whiteColor,
                              size: 30.sp,
                            ),
                          )
                          : Text(
                            "save".tr(),
                            style: AppTextStyle.styleBlack16Bold.copyWith(
                              color: AppColors.whiteColor,
                            ),
                          ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
