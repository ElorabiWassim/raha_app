import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';

class PickedLocation {
  final double latitude;
  final double longitude;
  final String? city;
  final String? neighborhood;
  final String displayAddress;

  const PickedLocation({
    required this.latitude,
    required this.longitude,
    required this.displayAddress,
    this.city,
    this.neighborhood,
  });
}

class LocationService {
  Future<Position> getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception('Location permission was denied.');
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permission is permanently denied. Please enable it in settings.',
      );
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<PickedLocation> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final placemarks = await geo.placemarkFromCoordinates(
        latitude,
        longitude,
      );
      final first = placemarks.isNotEmpty ? placemarks.first : null;

      final city = (first?.locality ?? first?.administrativeArea)?.trim();
      final neighborhood = (first?.subLocality ?? first?.subAdministrativeArea)
          ?.trim();

      final parts = <String>[];
      final name = first?.name?.trim();
      if (name != null && name.isNotEmpty) parts.add(name);
      if (neighborhood != null && neighborhood.isNotEmpty)
        parts.add(neighborhood);
      if (city != null && city.isNotEmpty) parts.add(city);

      final display = parts.isNotEmpty
          ? parts.join(', ')
          : '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';

      return PickedLocation(
        latitude: latitude,
        longitude: longitude,
        city: city,
        neighborhood: neighborhood,
        displayAddress: display,
      );
    } catch (_) {
      final display =
          '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';
      return PickedLocation(
        latitude: latitude,
        longitude: longitude,
        displayAddress: display,
      );
    }
  }
}
