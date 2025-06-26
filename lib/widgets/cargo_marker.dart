import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/cargo.dart';
import '../services/mission_service.dart';

class CargoMarker {
  static Marker create({
    required Cargo cargo,
    required BuildContext context,
    required VoidCallback onAccept, // To notify map screen
  }) {
    return Marker(
      markerId: MarkerId(cargo.id),
      position: LatLng(cargo.latitude, cargo.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      infoWindow: InfoWindow(
        title: cargo.name,
        snippet:
            'Reward: \$${cargo.reward.toStringAsFixed(0)} | Risk: ${(cargo.risk * 100).toStringAsFixed(0)}%',
        onTap: () {
          if (MissionService().isOnMission) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('You can only carry one cargo right now!'),
              ),
            );
            return;
          }

          showDialog(
            context: context,
            builder:
                (_) => AlertDialog(
                  title: Text('Pickup ${cargo.name}?'),
                  content: Text(
                    'Reward: \$${cargo.reward.toStringAsFixed(0)}\nRisk: ${(cargo.risk * 100).toStringAsFixed(0)}%',
                  ),
                  actions: [
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: Text('Accept'),
                      onPressed: () {
                        Navigator.pop(context);
                        MissionService().startMission(cargo);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('You picked up ${cargo.name}'),
                          ),
                        );
                        onAccept(); // Notifies parent screen
                      },
                    ),
                  ],
                ),
          );
        },
      ),
    );
  }
}
