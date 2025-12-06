import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/core/utils/assets/app_icons.dart';
import 'package:shift7_app/features/app/presentation/screens/widgets/custom_app_bar_loading_widget.dart';
import 'package:shift7_app/features/app/presentation/screens/widgets/custom_store_button_widget.dart';
import 'package:shift7_app/features/introduction/data/model/get_store_details_model.dart';
import 'package:shift7_app/features/introduction/presentation/cubit/intro_cubit.dart';

class CustomShift7AppBarWidget extends StatelessWidget {
  const CustomShift7AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IntroCubit, IntroState>(
      buildWhen:
          (prev, curr) =>
              prev.storeStatus != curr.storeStatus ||
              prev.storeDetails != curr.storeDetails,
      builder: (context, state) {
        final storeDetails = state.storeDetails;

        if (state.storeStatus == ApiStatus.loading || storeDetails == null) {
          return const CustomAppBarLoadingWidget();
        }

        final StoreItemData currentStore = storeDetails.store;

        final List<StoreItemData> allStores = List<StoreItemData>.from(
          storeDetails.stores.data,
        );

        if (!allStores.any((s) => s.id == currentStore.id)) {
          allStores.insert(0, currentStore);
        }

        allStores.sort((a, b) {
          if (a.id == currentStore.id) return -1;
          if (b.id == currentStore.id) return 1;
          return 0;
        });

        return Container(
          height: 64.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                AppIcons.appIcon,
                height: 45.h,
                width: 80.w,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 30.w),
              Expanded(
                child:
                    allStores.isEmpty
                        ? const SizedBox.shrink()
                        : Row(
                          children: List.generate(allStores.length, (idx) {
                            final store = allStores[idx];
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsetsDirectional.only(
                                  end: idx == allStores.length - 1 ? 0 : 5.w,
                                ),
                                child: SizedBox(
                                  height: 50.h,
                                  width: 50.w,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.center,
                                    child: CustomStoreButtonWidget(
                                      store: store,
                                      index: idx,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
              ),
            ],
          ),
        );
      },
    );
  }
}
