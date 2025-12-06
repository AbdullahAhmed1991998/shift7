import 'package:geocoding/geocoding.dart';

class ResolvedAddress {
  final String title;
  final String details;
  const ResolvedAddress(this.title, this.details);
}

class ReverseGeocodingService {
  ReverseGeocodingService._();
  static final ReverseGeocodingService instance = ReverseGeocodingService._();
  final Map<int, ResolvedAddress> _cache = {};

  Future<ResolvedAddress> resolve({
    required int addressId,
    required double lat,
    required double lng,
    required String localeIdentifier,
    String? fallbackLine1,
    String? fallbackCity,
    String? fallbackCountry,
  }) async {
    final cached = _cache[addressId];
    if (cached != null) return cached;
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        final p = placemarks.first;

        final title = _pickBest([
          p.subAdministrativeArea,
          p.locality,
          p.subLocality,
          p.administrativeArea,
          p.name,
        ]);

        final parts =
            <String?>[
              _pickBest([p.street, p.thoroughfare, p.name]),
              _pickBest([p.subLocality, p.locality]),
              _pickBest([p.subAdministrativeArea, p.administrativeArea]),
              p.postalCode,
              p.country,
            ].where((e) => e!.trim().isNotEmpty).cast<String>().toList();

        final details = parts.join(', ');

        final resolved = ResolvedAddress(
          title ??
              _pickBest([fallbackCity, fallbackLine1, fallbackCountry]) ??
              '',
          details.isNotEmpty
              ? details
              : _pickBest([fallbackLine1, fallbackCity, fallbackCountry]) ?? '',
        );

        _cache[addressId] = resolved;
        return resolved;
      }
    } catch (_) {}

    final resolved = ResolvedAddress(
      _pickBest([fallbackCity, fallbackLine1, fallbackCountry]) ?? '',
      _joinFallback([fallbackLine1, fallbackCity, fallbackCountry]),
    );
    _cache[addressId] = resolved;
    return resolved;
  }

  String? _pickBest(List<String?> options) {
    for (final s in options) {
      if (s != null && s.trim().isNotEmpty) return s.trim();
    }
    return null;
  }

  String _joinFallback(List<String?> options) => options
      .where((e) => e != null && e.trim().isNotEmpty)
      .cast<String>()
      .join(', ');
}
