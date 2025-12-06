import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/widgets/brand_category_filter_drop_down.dart';
import 'package:shift7_app/core/utils/widgets/price_filter_widget.dart';
import 'package:shift7_app/core/utils/widgets/rating_filter_widget.dart';
import 'package:shift7_app/features/app/data/models/filter_model.dart';
import 'package:shift7_app/features/home/presentation/cubit/home_cubit.dart';

class ProductFilterBar extends StatefulWidget {
  final List<Map<String, dynamic>> brands;
  final List<Map<String, dynamic>> categories;
  final FilterModel currentFilter;
  final void Function(FilterModel) onFilterChanged;
  final int? currentBrandId;
  final int? currentCategoryId;

  const ProductFilterBar({
    super.key,
    required this.brands,
    required this.categories,
    required this.currentFilter,
    required this.onFilterChanged,
    this.currentBrandId,
    this.currentCategoryId,
  });

  @override
  State<ProductFilterBar> createState() => _ProductFilterBarState();
}

class _ProductFilterBarState extends State<ProductFilterBar> {
  late FilterModel _filter;
  int _clearKey = 0;

  @override
  void initState() {
    super.initState();
    _resetFilter();
  }

  void _resetFilter() {
    _filter = FilterModel(
      selectedBrand:
          widget.currentFilter.selectedBrand != null
              ? List.from(widget.currentFilter.selectedBrand!)
              : (widget.currentBrandId != null
                  ? [widget.currentBrandId!]
                  : null),
      selectedCategory:
          widget.currentFilter.selectedCategory != null
              ? List.from(widget.currentFilter.selectedCategory!)
              : (widget.currentCategoryId != null
                  ? [widget.currentCategoryId!]
                  : null),
      selectedRating:
          widget.currentFilter.selectedRating != null
              ? List.from(widget.currentFilter.selectedRating!)
              : null,
      minPrice: widget.currentFilter.minPrice,
      maxPrice: widget.currentFilter.maxPrice,
    );
  }

  @override
  void didUpdateWidget(ProductFilterBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentFilter != oldWidget.currentFilter) {
      _resetFilter();
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _updateFilter() {
    if (mounted) {
      final updatedFilter = FilterModel(
        selectedBrand:
            _filter.selectedBrand != null && _filter.selectedBrand!.isNotEmpty
                ? _filter.selectedBrand
                : (widget.currentBrandId != null
                    ? [widget.currentBrandId!]
                    : null),
        selectedCategory:
            _filter.selectedCategory != null &&
                    _filter.selectedCategory!.isNotEmpty
                ? _filter.selectedCategory
                : (widget.currentCategoryId != null
                    ? [widget.currentCategoryId!]
                    : null),
        selectedRating: _filter.selectedRating,
        minPrice: _filter.minPrice,
        maxPrice: _filter.maxPrice,
      );
      widget.onFilterChanged(updatedFilter);
    }
  }

  void _clearAllFilters() {
    if (mounted) {
      setState(() {
        _filter.clearFilters();
        _clearKey++;
      });

      final emptyFilter = FilterModel(
        selectedBrand:
            widget.currentBrandId != null ? [widget.currentBrandId!] : null,
        selectedCategory:
            widget.currentCategoryId != null
                ? [widget.currentCategoryId!]
                : null,
      );
      widget.onFilterChanged(emptyFilter);
    }
  }

  bool get _hasUserFilters {
    final hasRating =
        _filter.selectedRating != null && _filter.selectedRating!.isNotEmpty;
    final hasPrice = _filter.minPrice != null || _filter.maxPrice != null;
    final hasExtraBrands =
        _filter.selectedBrand != null &&
        _filter.selectedBrand!.length > (widget.currentBrandId != null ? 1 : 0);
    final hasExtraCategories =
        _filter.selectedCategory != null &&
        _filter.selectedCategory!.length >
            (widget.currentCategoryId != null ? 1 : 0);

    return hasRating || hasPrice || hasExtraBrands || hasExtraCategories;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Container(
          height: 60.h,
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            children: [
              if (widget.currentBrandId == null) ...[
                BrandCategoryFilterDropdown(
                  key: ValueKey('brands_$_clearKey'),
                  items: state.brandsForFilter,
                  selectedIds: _filter.selectedBrand,
                  hintText: "brands".tr(),
                  isLoadingMore: state.brandsLoadingMore,
                  hasMore: state.brandsHasMore,
                  onLoadMore:
                      state.canLoadMoreBrands
                          ? () => context.read<HomeCubit>().loadMoreBrands(
                            categoryId: widget.currentCategoryId!,
                          )
                          : null,
                  onChanged: (selectedIds) {
                    if (mounted) {
                      setState(() {
                        _filter.selectedBrand =
                            selectedIds.isEmpty ? null : selectedIds;
                      });
                      _updateFilter();
                    }
                  },
                ),
                SizedBox(width: 12.w),
              ],

              if (widget.currentCategoryId == null) ...[
                BrandCategoryFilterDropdown(
                  key: ValueKey('categories_$_clearKey'),
                  items: state.categoriesForFilter,
                  selectedIds: _filter.selectedCategory,
                  hintText: "categories".tr(),
                  isLoadingMore: state.categoriesLoadingMore,
                  hasMore: state.categoriesHasMore,
                  onLoadMore:
                      state.canLoadMoreCategories
                          ? () => context.read<HomeCubit>().loadMoreCategories(
                            brandId: widget.currentBrandId!,
                          )
                          : null,
                  onChanged: (selectedIds) {
                    if (mounted) {
                      setState(() {
                        _filter.selectedCategory =
                            selectedIds.isEmpty ? null : selectedIds;
                      });
                      _updateFilter();
                    }
                  },
                ),
                SizedBox(width: 12.w),
              ],

              RatingFilterWidget(
                key: ValueKey(
                  'rating_${_filter.selectedRating?.length ?? 0}_$_clearKey',
                ),
                selectedRating:
                    _filter.selectedRating?.isNotEmpty == true
                        ? _filter.selectedRating!.first
                        : null,
                onRatingChanged: (selectedRating) {
                  if (mounted) {
                    setState(() {
                      _filter.selectedRating =
                          selectedRating != null ? [selectedRating] : null;
                    });
                    _updateFilter();
                  }
                },
              ),

              SizedBox(width: 12.w),

              PriceFilterWidget(
                key: ValueKey(
                  'price_${_filter.minPrice}_${_filter.maxPrice}_$_clearKey',
                ),
                minPrice: _filter.minPrice,
                maxPrice: _filter.maxPrice,
                onPriceChanged: (min, max) {
                  if (mounted) {
                    setState(() {
                      _filter.minPrice = min;
                      _filter.maxPrice = max;
                    });
                    _updateFilter();
                  }
                },
              ),

              if (_hasUserFilters) ...[
                SizedBox(width: 12.w),
                GestureDetector(
                  onTap: _clearAllFilters,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withAlpha(25),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: Colors.red.withAlpha(76),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.clear, color: Colors.red, size: 16.sp),
                        SizedBox(width: 4.w),
                        Text(
                          "clear_all".tr(),
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14.sp,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
