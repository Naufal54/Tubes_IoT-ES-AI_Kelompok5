import 'package:fall_detection_app/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapContainer extends StatefulWidget {
  final LatLng initialPosition;

  const MapContainer({super.key, required this.initialPosition});

  @override
  State<MapContainer> createState() => _MapContainerState();
}

class _MapContainerState extends State<MapContainer> {
  late MapController mapController;
  late LatLng currentPosition;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    currentPosition = widget.initialPosition;
  }

  void _goToInitialPosition() {
    mapController.move(widget.initialPosition, 14);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: widget.initialPosition,
                initialZoom: 14,
                onPositionChanged: (position, _) {
                  setState(() {
                    currentPosition = position.center!;
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.falldetectionapp',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: widget.initialPosition,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // ===== LatLng Display di kiri bawah =====
            Positioned(
              left: 10,
              bottom: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.5),
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Lat: ${currentPosition.latitude.toStringAsFixed(5)}, '
                  'Lng: ${currentPosition.longitude.toStringAsFixed(5)}',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ),
            ),

            // ===== Tombol kembali ke posisi awal di kanan bawah =====
            Positioned(
              right: 10,
              bottom: 10,
              child: Container(
                width: 50, 
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.secondaryBlue, width: 0.5),
                ),
                child: IconButton(
                  icon: const Icon(Icons.my_location),
                  color: AppColors.primaryBlue, 
                  onPressed: _goToInitialPosition,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
