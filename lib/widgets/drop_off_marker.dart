import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/cargo.dart';
import '../services/mission_service.dart';

class DropOffMarker {
  static Marker create({
    required Cargo cargo,
    required LatLng position, // New: pass drop-off location
    required BuildContext context,
    required VoidCallback onDelivered,
  }) {
    return Marker(
      markerId: MarkerId('dropoff_${cargo.id}'),
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(
        title: 'Deliver ${cargo.name}',
        snippet: 'Tap to complete delivery',
        onTap: () {
          MissionService().completeMission();

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Delivered ${cargo.name}!')));

          onDelivered();
        },
      ),
    );
  }
}
