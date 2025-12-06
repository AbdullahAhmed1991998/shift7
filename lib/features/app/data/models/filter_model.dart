class FilterModel {
  List<int>? selectedBrand;
  List<int>? selectedCategory;
  List<int>? selectedRating;
  int? minPrice;
  int? maxPrice;

  FilterModel({
    this.selectedBrand,
    this.selectedCategory,
    this.selectedRating,
    this.minPrice,
    this.maxPrice,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (selectedBrand != null && selectedBrand!.isNotEmpty) {
      data['brand_ids'] = selectedBrand;
    }
    if (selectedCategory != null && selectedCategory!.isNotEmpty) {
      data['category_ids'] = selectedCategory;
    }
    if (selectedRating != null) {
      data['rate'] = selectedRating;
    }
    if (minPrice != null) {
      data['min_price'] = minPrice;
    }
    if (maxPrice != null) {
      data['max_price'] = maxPrice;
    }
    return data;
  }

  bool get hasFilters {
    return selectedBrand != null && selectedBrand!.isNotEmpty ||
        selectedCategory != null && selectedCategory!.isNotEmpty ||
        selectedRating != null ||
        minPrice != null ||
        maxPrice != null;
  }

  void clearFilters() {
    selectedBrand = null;
    selectedCategory = null;
    selectedRating = null;
    minPrice = null;
    maxPrice = null;
  }
}
