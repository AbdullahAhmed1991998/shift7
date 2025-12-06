import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shift7_app/core/functions/show_toast.dart';
import 'package:shift7_app/core/network/api_keys.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/cache_helper_keys.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_bar.dart';
import 'package:shift7_app/features/app/data/models/product_reviews_model.dart';
import 'package:shift7_app/features/app/presentation/screens/widgets/custom_reviews_list_view_widget.dart';
import 'package:shift7_app/features/introduction/presentation/cubit/intro_cubit.dart';

class ProductReviewScreen extends StatefulWidget {
  final bool isReviewPage;
  final List<ProductReviewsModel> reviewsList;
  final int productId;

  const ProductReviewScreen({
    super.key,
    required this.isReviewPage,
    required this.reviewsList,
    required this.productId,
  });

  @override
  State<ProductReviewScreen> createState() => _ProductReviewScreenState();
}

class _ProductReviewScreenState extends State<ProductReviewScreen> {
  int _selectedRating = 0;
  final TextEditingController _messageController = TextEditingController();
  late List<ProductReviewsModel> _reviews;
  bool isLoggedIn = false;
  bool isLoading = true;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _reviews = List.from(widget.reviewsList);
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final token = await _secureStorage.read(key: userToken);
    if (mounted) {
      setState(() {
        isLoggedIn = token?.isNotEmpty == true;
        isLoading = false;
      });
    }
  }

  void _submitReview() {
    if (_selectedRating > 0 && _messageController.text.isNotEmpty) {
      final userId = 1;
      final newReview = ProductReviewsModel(
        id: _reviews.length + 1,
        rate: _selectedRating,
        message: _messageController.text,
        userId: userId,
        modelId: widget.productId,
        createdAt: DateTime.now(),
        user: User(
          id: userId,
          name:
              getIt<CacheHelper>().getData(key: CacheHelperKeys.userName) ??
              'Guest',
          typeDescription: null,
        ),
      );
      setState(() => _reviews.insert(0, newReview));
      context.read<IntroCubit>().sendProductReview(
        productId: widget.productId,
        message: _messageController.text,
        rate: _selectedRating,
      );
      setState(() {
        _selectedRating = 0;
        _messageController.clear();
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<IntroCubit, IntroState>(
      listenWhen:
          (prev, curr) =>
              prev.sendProductReviewStatus != curr.sendProductReviewStatus &&
              (curr.sendProductReviewStatus == ApiStatus.success ||
                  curr.sendProductReviewStatus == ApiStatus.error),
      listener: (context, state) {
        if (state.sendProductReviewStatus == ApiStatus.success) {
          showToast(
            context,
            isSuccess: true,
            message: 'reviewSubmittedSuccessfully'.tr(),
            icon: Icons.check_circle,
          );
        } else if (state.sendProductReviewStatus == ApiStatus.error) {
          showToast(
            context,
            isSuccess: false,
            message: state.sendProductReviewErrorMessage ?? 'auth_failed'.tr(),
            icon: Icons.error,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.h),
          child: CustomAppBar(
            title: 'reviews'.tr(),
            onBackPressed: () {
              Navigator.pushReplacementNamed(
                context,
                AppRoutesKeys.product,
                arguments: {"productId": widget.productId},
              );
            },
          ),
        ),
        body:
            isLoading
                ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                )
                : SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 16.h),
                      if (isLoggedIn) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(10.r),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryColor.withAlpha(50),
                                  blurRadius: 12.r,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    5,
                                    (i) => GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedRating = i + 1;
                                        });
                                      },
                                      child: Icon(
                                        i < _selectedRating
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: AppColors.secondaryColor,
                                        size: 32.sp,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                TextFormField(
                                  controller: _messageController,
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                    hintText: 'writeYourReview'.tr(),
                                    hintStyle: AppTextStyle.styleBlack12W400
                                        .copyWith(color: AppColors.greyColor),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      borderSide: BorderSide(
                                        color: AppColors.greyColor,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      borderSide: BorderSide(
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                BlocBuilder<IntroCubit, IntroState>(
                                  builder: (context, state) {
                                    if (state.sendProductReviewStatus ==
                                        ApiStatus.loading) {
                                      return Center(
                                        child:
                                            LoadingAnimationWidget.staggeredDotsWave(
                                              color: AppColors.secondaryColor,
                                              size: 30.sp,
                                            ),
                                      );
                                    }
                                    return SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: _submitReview,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 24.w,
                                            vertical: 12.h,
                                          ),
                                        ),
                                        child: Text(
                                          'submit'.tr(),
                                          style: AppTextStyle.styleBlack14W500
                                              .copyWith(
                                                color: AppColors.whiteColor,
                                              ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                      ],
                      CustomReviewsListViewWidget(
                        reviews: _reviews,
                        isReviewPage: widget.isReviewPage,
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
      ),
    );
  }
}
