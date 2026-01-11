import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'location_service.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key, this.initialCenter});

  final LatLng? initialCenter;

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late LatLng _center;
  final _mapController = MapController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _center = widget.initialCenter ?? const LatLng(36.7525, 3.0420); // Algiers
  }

  Future<void> _select() async {
    if (_saving) return;
    setState(() => _saving = true);

    try {
      final location = await LocationService().reverseGeocode(
        latitude: _center.latitude,
        longitude: _center.longitude,
      );
      if (!mounted) return;
      Navigator.pop(context, location);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick location'),
        backgroundColor: const Color(0xFF68E36C),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 14,
              onPositionChanged: (pos, _) {
                final c = pos.center;
                if (c != null) _center = c;
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'ra7a',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _center,
                    width: 44,
                    height: 44,
                    child: const Icon(
                      Icons.location_on,
                      color: Color(0xFF33AD04),
                      size: 44,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: SafeArea(
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _saving ? null : _select,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF33AD04),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Select this location'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
