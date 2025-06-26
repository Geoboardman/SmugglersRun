import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/cargo.dart';

class CargoGenerator {
  static List<Cargo> generateNearbyCargo(
    LatLng playerPosition, {
    int count = 3,
  }) {
    final Random rng = Random();
    List<Cargo> cargos = [];

    for (int i = 0; i < count; i++) {
      double offsetLat = (rng.nextDouble() - 0.5) / 500; // ~0.001 = ~111m
      double offsetLng = (rng.nextDouble() - 0.5) / 500;

      cargos.add(
        Cargo(
          id: 'cargo_$i',
          name: 'Contraband ${i + 1}',
          reward: 50 + rng.nextInt(100).toDouble(),
          risk: rng.nextDouble(),
          latitude: playerPosition.latitude + offsetLat,
          longitude: playerPosition.longitude + offsetLng,
        ),
      );
    }

    return cargos;
  }
}
