import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';

void showToast(
  BuildContext context, {
  required bool? isSuccess,
  required String message,
  required IconData icon,
}) {
  final isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(message);
  final dir = isArabic ? TextDirection.rtl : TextDirection.ltr;

  DelightToastBar? toast;
  toast = DelightToastBar(
    builder:
        (context) => Directionality(
          textDirection: dir,
          child: ToastCard(
            leading: Icon(
              icon,
              size: 20.sp,
              color: isSuccess == true ? Colors.green : Colors.red,
            ),
            title: Text(
              message,
              textAlign: TextAlign.start,
              style: AppTextStyle.styleBlack14W500,
            ),
            shadowColor: Colors.black26,
            color: Colors.white,
            trailing: IconButton(
              onPressed: () {
                toast?.remove();
              },
              icon: Icon(Icons.close, size: 20.sp, color: Colors.black),
            ),
          ),
        ),
    animationCurve: Curves.easeOutBack,
    animationDuration: const Duration(milliseconds: 400),
    snackbarDuration: const Duration(seconds: 3),
    position: DelightSnackbarPosition.bottom,
    autoDismiss: true,
  );
  toast.show(context);
}
