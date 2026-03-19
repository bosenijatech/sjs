

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

class OfflineAddressResolver {
  static Future<AddressResult> resolve(
    double lat,
    double lng,
  ) async {
    // ✅ STEP 1: Try native geocoder first (fastest)
    try {
      final placemarks = await placemarkFromCoordinates(
        lat,
        lng,
      ).timeout(const Duration(seconds: 5));

      if (placemarks.isNotEmpty) {
        final address = _buildAddress(placemarks);
        if (address.isNotEmpty && !_looksLikeCoordinates(address)) {
          debugPrint("✅ Native geocoder: $address");
          return AddressResult(
            address: address,
            source: AddressSource.nativeGeocoder,
          );
        }
      }
    } catch (e) {
      debugPrint("⚠ Native geocoder failed: $e");
      // Fall through to Nominatim fallback
    }

    // ✅ STEP 2: If native fails, try Nominatim (works online or offline with cache)
    try {
      final nominatimAddress = await _nominatimReverse(lat, lng);
      if (nominatimAddress != null && nominatimAddress.isNotEmpty) {
        debugPrint("✅ Nominatim fallback: $nominatimAddress");
        return AddressResult(
          address: nominatimAddress,
          source: AddressSource.nominatimFallback,
        );
      }
    } catch (e) {
      debugPrint("⚠ Nominatim fallback failed: $e");
    }

    // ✅ STEP 3: Last resort - coordinates
    final coordStr = "${lat.toStringAsFixed(6)},${lng.toStringAsFixed(6)}";
    debugPrint("📍 Fallback coordinates: $coordStr");
    return AddressResult(
      address: coordStr,
      source: AddressSource.coordinates,
    );
  }

  static String displayAddress(String rawAddress) {
    if (!_looksLikeCoordinates(rawAddress)) return rawAddress;

    final parts = rawAddress.split(',');
    if (parts.length != 2) return rawAddress;

    final lat = double.tryParse(parts[0].trim());
    final lng = double.tryParse(parts[1].trim());
    if (lat == null || lng == null) return rawAddress;

    final latDir = lat >= 0 ? 'N' : 'S';
    final lngDir = lng >= 0 ? 'E' : 'W';
    return "📍 ${lat.abs().toStringAsFixed(4)}°$latDir, "
        "${lng.abs().toStringAsFixed(4)}°$lngDir";
  }

  static bool _looksLikeCoordinates(String address) {
    final parts = address.split(',');
    if (parts.length != 2) return false;
    return double.tryParse(parts[0].trim()) != null &&
        double.tryParse(parts[1].trim()) != null;
  }

  /// ✅ Native geocoder parsing
  static String _buildAddress(List<Placemark> placemarks) {
    if (placemarks.isEmpty) return "";

    final parts = <String>[];

    void add(String? val) {
      if (val == null) return;
      final v = val.trim();
      if (v.isEmpty) return;
      if (parts.any((p) => p.toLowerCase() == v.toLowerCase())) return;
      parts.add(v);
    }

    // 1. Street from first placemark
    add(placemarks.first.street);

    // 2. Locality from first placemark (village - Palaya Appaneri)
    add(placemarks.first.locality);

    // 3. SubLocality (Kovilpatti) - from placemark that has it
    // 4. City Locality (Thoothukudi) - from same placemark
    for (int i = 1; i < placemarks.length; i++) {
      final subLoc = placemarks[i].subLocality?.trim();
      if (subLoc != null && subLoc.isNotEmpty) {
        add(subLoc);
        
        final cityLocality = placemarks[i].locality?.trim();
        if (cityLocality != null && 
            cityLocality.isNotEmpty &&
            cityLocality.toLowerCase() != placemarks.first.locality?.toLowerCase()) {
          add(cityLocality);
        }
        break;
      }
    }

    // 5. SubAdministrativeArea (district)
    for (final p in placemarks) {
      final subAdmin = p.subAdministrativeArea?.trim();
      if (subAdmin != null && subAdmin.isNotEmpty) {
        add(subAdmin);
        break;
      }
    }

    // 6. Administrative area (state)
    for (final p in placemarks) {
      final admin = p.administrativeArea?.trim();
      if (admin != null && admin.isNotEmpty) {
        add(admin);
        break;
      }
    }

    // 7. Postal code
    for (final p in placemarks) {
      final postal = p.postalCode?.trim();
      if (postal != null && postal.isNotEmpty) {
        add(postal);
        break;
      }
    }

    // 8. Country
    for (final p in placemarks) {
      final country = p.country?.trim();
      if (country != null && country.isNotEmpty) {
        add(country);
        break;
      }
    }

    return parts.join(', ').replaceAll(RegExp(r',\s*,'), ',').trim();
  }

  /// ✅ Nominatim fallback - same hierarchy as native geocoder
  static Future<String?> _nominatimReverse(double lat, double lng) async {
    try {
      final uri = Uri.parse(
        "https://nominatim.openstreetmap.org/reverse"
        "?lat=$lat&lon=$lng&format=json&addressdetails=1",
      );

      final response = await http.get(
        uri,
        headers: {
          "User-Agent": "WinstarAttendanceApp/1.0",
          "Accept-Language": "en",
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final addr = data['address'] as Map<String, dynamic>?;
      if (addr == null) return null;

      final parts = <String>[];

      void add(String? val) {
        if (val == null) return;
        final v = val.trim();
        if (v.isEmpty) return;
        if (parts.any((p) => p.toLowerCase() == v.toLowerCase())) return;
        parts.add(v);
      }

      // Same hierarchy as native geocoder
      final street = (addr['road'] 
          ?? addr['pedestrian'] 
          ?? addr['path']
          ?? addr['footway']
          ?? addr['residential']) as String?;
      add(street);

      add(addr['neighbourhood'] as String?);
      add(addr['suburb'] as String?);
      add(addr['village'] as String?);
      
      add(addr['town'] as String?);
      add(addr['city'] as String?);
      add(addr['municipality'] as String?);

      final county = addr['county'] as String?;
      if (county != null && !parts.any((p) => p.toLowerCase() == county.toLowerCase())) {
        add(county);
      }

      add(addr['state_district'] as String?);
      add(addr['state'] as String?);
      add(addr['postcode'] as String?);
      add(addr['country'] as String?);

      if (parts.isEmpty) return null;

      return parts.join(', ').replaceAll(RegExp(r',\s*,'), ',').trim();

    } catch (e) {
      debugPrint("⚠ Nominatim: $e");
      return null;
    }
  }
}

enum AddressSource {
  nativeGeocoder,      // Android native - fastest
  nominatimFallback,   // Nominatim fallback when native fails
  coordinates,         // Last resort - just lat,lng
}

class AddressResult {
  final String address;
  final AddressSource source;

  const AddressResult({
    required this.address,
    required this.source,
  });

  bool get isCoordinates => source == AddressSource.coordinates;
  bool get isProperAddress => source != AddressSource.coordinates;
}