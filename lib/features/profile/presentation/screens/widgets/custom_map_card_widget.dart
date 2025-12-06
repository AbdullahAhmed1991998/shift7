import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:shift7_app/core/utils/style/app_colors.dart';

class CustomMapCardWidget extends StatelessWidget {
  final bool isLoading;
  final bool locationGranted;
  final LatLng initialTarget;
  final double initialZoom;
  final double focusZoom;
  final Marker? currentMarker;

  final ValueChanged<GoogleMapController>? onMapCreated;
  final ValueChanged<LatLng>? onMapTap;
  final VoidCallback? onLocateMePressed;

  final String locateMeLabel;

  const CustomMapCardWidget({
    super.key,
    required this.isLoading,
    required this.locationGranted,
    required this.initialTarget,
    required this.initialZoom,
    required this.focusZoom,
    required this.currentMarker,
    required this.locateMeLabel,
    this.onMapCreated,
    this.onMapTap,
    this.onLocateMePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 0.3.sh,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(60),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          children: [
            Positioned.fill(
              child:
                  isLoading
                      ? const Center(
                        child: CircularProgressIndicator(strokeWidth: 2.6),
                      )
                      : GoogleMap(
                        myLocationEnabled: locationGranted,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        compassEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: initialTarget,
                          zoom: initialZoom,
                        ),
                        onMapCreated: (c) => onMapCreated?.call(c),
                        markers: {if (currentMarker != null) currentMarker!},
                        onTap: (latLng) => onMapTap?.call(latLng),
                      ),
            ),
            Positioned(
              right: 12.w,
              bottom: 12.h,
              child: Material(
                color: Colors.white,
                elevation: 8,
                borderRadius: BorderRadius.circular(28.r),
                child: InkWell(
                  onTap: onLocateMePressed,
                  borderRadius: BorderRadius.circular(28.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.my_location_rounded,
                          size: 18.r,
                          color: AppColors.primaryColor,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          locateMeLabel,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
