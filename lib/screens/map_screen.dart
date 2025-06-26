import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';
import '../services/cargo_generator.dart';
import '../widgets/cargo_marker.dart';
import '../models/cargo.dart';
import '../services/mission_service.dart';
import 'dart:math';
import '../widgets/drop_off_marker.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  LatLng _currentPosition = const LatLng(37.7749, -122.4194); // default to SF
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    final position = await LocationService.getCurrentLocation();
    _updatePlayerLocation(position);

    // Start real-time updates
    LocationService.getLocationStream().listen((Position pos) {
      _updatePlayerLocation(pos);
    });
  }

  LatLng _generateDropOffLocation(
    LatLng origin, {
    double distanceInMeters = 500,
  }) {
    final random = Random();
    final dx = (random.nextDouble() - 0.5) * 2;
    final dy = (random.nextDouble() - 0.5) * 2;

    // Roughly ~111,000 meters per degree of latitude
    final offsetLat = dy * distanceInMeters / 111000;
    final offsetLng =
        dx * distanceInMeters / (111000 * cos(origin.latitude * pi / 180));

    return LatLng(origin.latitude + offsetLat, origin.longitude + offsetLng);
  }

  void _updatePlayerLocation(Position pos) {
    final newPosition = LatLng(pos.latitude, pos.longitude);
    setState(() {
      _currentPosition = newPosition;
      List<Cargo> nearbyCargo = CargoGenerator.generateNearbyCargo(
        _currentPosition,
      );
      for (var cargo in nearbyCargo) {
        _markers.add(
          CargoMarker.create(
            cargo: cargo,
            context: context,
            onAccept: () {
              final dropOffLocation = _generateDropOffLocation(
                LatLng(cargo.latitude, cargo.longitude),
              );

              final dropOffMarker = DropOffMarker.create(
                cargo: cargo,
                position: dropOffLocation,
                context: context,
                onDelivered: () {
                  setState(() {
                    _markers.removeWhere(
                      (m) => m.markerId.value == 'dropoff_${cargo.id}',
                    );
                  });
                },
              );

              setState(() {
                _markers.add(dropOffMarker);
              });
            },
          ),
        );
      }
      _markers.removeWhere((m) => m.markerId.value == 'player');
      _markers.add(
        Marker(
          markerId: MarkerId('player'),
          position: newPosition,
          infoWindow: InfoWindow(title: "You"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    });

    // Optional: move camera to follow player
    _mapController?.animateCamera(CameraUpdate.newLatLng(newPosition));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Smuggler's Run")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentPosition,
          zoom: 16,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: _markers,
        onMapCreated: (controller) => _mapController = controller,
      ),
    );
  }
}
