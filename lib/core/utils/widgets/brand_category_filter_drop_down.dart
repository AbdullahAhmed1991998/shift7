import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';

class BrandCategoryFilterDropdown extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final List<int>? selectedIds;
  final String? hintText;
  final void Function(List<int>)? onChanged;
  final Color? fillColor;
  final VoidCallback? onLoadMore;
  final bool isLoadingMore;
  final bool hasMore;

  const BrandCategoryFilterDropdown({
    super.key,
    required this.items,
    this.selectedIds,
    this.hintText,
    this.onChanged,
    this.fillColor,
    this.onLoadMore,
    this.isLoadingMore = false,
    this.hasMore = true,
  });

  @override
  State<BrandCategoryFilterDropdown> createState() =>
      _BrandCategoryFilterDropdownState();
}

class _BrandCategoryFilterDropdownState
    extends State<BrandCategoryFilterDropdown>
    with WidgetsBindingObserver {
  List<int> _selectedIds = [];
  final _focusNode = FocusNode();
  final _overlayKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  bool _disposed = false;
  StateSetter? _overlaySetState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.selectedIds != null) {
      _selectedIds = List.from(widget.selectedIds!);
    }
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (widget.onLoadMore == null) return;
    if (!widget.hasMore) return;
    if (widget.isLoadingMore) return;

    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 50) {
      widget.onLoadMore!();
    }
  }

  @override
  void didUpdateWidget(BrandCategoryFilterDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldSelectedIds = oldWidget.selectedIds ?? [];
    final newSelectedIds = widget.selectedIds ?? [];

    if (oldSelectedIds.length != newSelectedIds.length ||
        !oldSelectedIds.every(newSelectedIds.contains)) {
      if (!_disposed) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !_disposed) {
            setState(() {
              _selectedIds = List.from(newSelectedIds);
            });

            if (_isOpen && _overlaySetState != null) {
              _overlaySetState!(() {});
            }
          }
        });
      }
    }

    if (_isOpen && _overlaySetState != null) {
      if (oldWidget.items.length != widget.items.length ||
          oldWidget.isLoadingMore != widget.isLoadingMore ||
          oldWidget.hasMore != widget.hasMore) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !_disposed && _overlaySetState != null) {
            _overlaySetState!(() {});
          }
        });
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _forceRemoveOverlay();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    WidgetsBinding.instance.removeObserver(this);
    _focusNode.dispose();
    _scrollController.dispose();
    _forceRemoveOverlay();
    super.dispose();
  }

  void _safeSetState(VoidCallback fn) {
    if (mounted && !_disposed) {
      setState(fn);
    }
  }

  void _forceRemoveOverlay() {
    try {
      _overlayEntry?.remove();
      _overlayEntry?.dispose();
    } finally {
      _overlayEntry = null;
      _overlaySetState = null;
      _isOpen = false;
    }
  }

  void _showOverlay() {
    if (_overlayEntry != null || !mounted || _disposed) return;

    final RenderBox? renderBox =
        _overlayKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !mounted || _disposed) return;

    try {
      final size = renderBox.size;
      final offset = renderBox.localToGlobal(Offset.zero);
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      final availableHeight = screenHeight - offset.dy - size.height - 20.h;
      final maxHeight = availableHeight > 250.h ? 250.h : availableHeight;

      _safeSetState(() {
        _isOpen = true;
      });

      _overlayEntry = OverlayEntry(
        builder:
            (context) => StatefulBuilder(
              builder: (context, setState) {
                _overlaySetState = setState;

                return Stack(
                  children: [
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: _removeOverlay,
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                    Positioned(
                      left: 16.w,
                      right: 16.w,
                      top: offset.dy + size.height + 4.h,
                      child: Material(
                        elevation: 8.0,
                        borderRadius: BorderRadius.circular(8.r),
                        child: Container(
                          width: screenWidth - 32.w,
                          constraints: BoxConstraints(maxHeight: maxHeight),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: AppColors.primaryColor,
                              width: 1,
                            ),
                          ),
                          child:
                              widget.items.isEmpty
                                  ? _buildEmptyState()
                                  : Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (_selectedIds.isNotEmpty)
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12.w,
                                            vertical: 8.h,
                                          ),
                                          child: TextButton(
                                            onPressed: () {
                                              if (!_disposed) {
                                                _safeSetState(() {
                                                  _selectedIds.clear();
                                                });
                                                setState(() {});
                                                widget.onChanged?.call(
                                                  _selectedIds,
                                                );
                                              }
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: Colors.red
                                                  .withAlpha(30),
                                              padding: EdgeInsets.symmetric(
                                                vertical: 6.h,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6.r),
                                              ),
                                            ),
                                            child: Text(
                                              "clear_all".tr(),
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 12.sp,
                                                fontFamily: 'Cairo',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      Flexible(
                                        child: ListView.builder(
                                          controller: _scrollController,
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          itemCount:
                                              widget.items.length +
                                              (widget.isLoadingMore ? 1 : 0),
                                          itemBuilder: (context, index) {
                                            if (index >= widget.items.length) {
                                              return Container(
                                                padding: EdgeInsets.all(16.w),
                                                alignment: Alignment.center,
                                                child: SizedBox(
                                                  height: 20.h,
                                                  width: 20.w,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color:
                                                            AppColors
                                                                .primaryColor,
                                                      ),
                                                ),
                                              );
                                            }

                                            final item = widget.items[index];
                                            final itemId = item["id"];
                                            bool isArabic =
                                                getIt<CacheHelper>().getData(
                                                  key: 'language',
                                                ) ==
                                                'ar';
                                            final itemName =
                                                isArabic
                                                    ? item["name_ar"]
                                                    : item["name_en"];
                                            final isSelected = _selectedIds
                                                .contains(itemId);

                                            return GestureDetector(
                                              onTap: () {
                                                if (!_disposed) {
                                                  _safeSetState(() {
                                                    if (isSelected) {
                                                      _selectedIds.remove(
                                                        itemId,
                                                      );
                                                    } else {
                                                      _selectedIds.add(itemId!);
                                                    }
                                                  });
                                                  setState(() {});
                                                  widget.onChanged?.call(
                                                    _selectedIds,
                                                  );
                                                }
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 12.w,
                                                  vertical: 10.h,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 20.w,
                                                      height: 20.h,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color:
                                                            isSelected
                                                                ? AppColors
                                                                    .primaryColor
                                                                : Colors
                                                                    .grey
                                                                    .shade300,
                                                        border: Border.all(
                                                          color:
                                                              isSelected
                                                                  ? AppColors
                                                                      .primaryColor
                                                                  : Colors
                                                                      .grey
                                                                      .shade400,
                                                          width: 1,
                                                        ),
                                                      ),
                                                      child:
                                                          isSelected
                                                              ? Icon(
                                                                Icons.check,
                                                                color:
                                                                    Colors
                                                                        .white,
                                                                size: 12.sp,
                                                              )
                                                              : null,
                                                    ),
                                                    SizedBox(width: 10.w),
                                                    Expanded(
                                                      child: Text(
                                                        itemName ?? "",
                                                        style: TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 14.sp,
                                                          fontFamily: 'Cairo',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
      );

      if (mounted && !_disposed && context.mounted) {
        Overlay.of(context).insert(_overlayEntry!);
      }
    } catch (e) {
      _forceRemoveOverlay();
    }
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 40.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 48.sp,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 12.h),
          Text(
            "no_brands_available".tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14.sp,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _removeOverlay() {
    _forceRemoveOverlay();
    _safeSetState(() {
      _isOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _overlayKey,
      onTap: () {
        if (_disposed) return;
        if (_isOpen) {
          _removeOverlay();
        } else {
          _showOverlay();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color:
                _selectedIds.isNotEmpty
                    ? AppColors.primaryColor
                    : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                widget.hintText ?? '',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.sp,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (_selectedIds.isNotEmpty) ...[
              SizedBox(width: 6.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  '${_selectedIds.length}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            SizedBox(width: 6.w),
            Icon(
              _isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.black,
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }
}
