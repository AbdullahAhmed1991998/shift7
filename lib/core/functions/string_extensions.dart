extension TitleCaseX on String {
  String englishTitleCase() {
    if (isEmpty) return this;
    final lower = toLowerCase();
    return lower.replaceAllMapped(
      RegExp(r'\b[a-z]'),
      (m) => m.group(0)!.toUpperCase(),
    );
  }
}
