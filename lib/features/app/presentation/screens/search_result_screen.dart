import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/enums/search_tab.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_bar.dart';
import 'package:shift7_app/features/introduction/presentation/cubit/intro_cubit.dart';
import 'widgets/custom_search_bar_widget.dart';
import 'widgets/custom_tab_selector_widget.dart';
import 'widgets/custom_search_results_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({super.key});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  SearchTab _selectedTab = SearchTab.products;
  Timer? _debounceTimer;
  String _currentQuery = '';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _setupSearchListener();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void _setupSearchListener() {
    _searchController.addListener(() {
      _onSearchChanged(_searchController.text);
    });
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();

    if (query.trim().isEmpty) {
      setState(() => _currentQuery = '');
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 100), () {
      if (query.trim() != _currentQuery && query.trim().isNotEmpty) {
        setState(() => _currentQuery = query.trim());
        _performSearch(query.trim());
      }
    });
  }

  void _performSearch(String query) {
    context.read<IntroCubit>().getSearch(query: query);
    _animationController.forward();
  }

  void _onTabChanged(SearchTab tab) {
    setState(() => _selectedTab = tab);
  }

  void _onClearSearch() {
    _searchController.clear();
    setState(() => _currentQuery = '');
    _animationController.reset();
  }

  void _onSearchSubmitted(String value) {
    if (value.trim().isNotEmpty) {
      _performSearch(value.trim());
    }
  }

  void _onRetrySearch() {
    _performSearch(_currentQuery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.h),
        child: CustomAppBar(
          title: "search".tr(),
          onBackPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          CustomSearchBarWidget(
            controller: _searchController,
            focusNode: _searchFocusNode,
            onClear: _onClearSearch,
            onSubmitted: _onSearchSubmitted,
          ),
          CustomTabSelectorWidget(
            selectedTab: _selectedTab,
            onTabChanged: _onTabChanged,
          ),
          Expanded(
            child: CustomSearchResultsWidget(
              currentQuery: _currentQuery,
              selectedTab: _selectedTab,
              fadeAnimation: _fadeAnimation,
              onRetry: _onRetrySearch,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
