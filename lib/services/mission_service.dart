// mission_service.dart
import '../models/cargo.dart';

class MissionService {
  static final MissionService _instance = MissionService._internal();
  factory MissionService() => _instance;

  MissionService._internal();

  Cargo? _activeCargo; // Only one for now — change to List<Cargo> later

  bool get isOnMission => _activeCargo != null;
  Cargo? get activeCargo => _activeCargo;

  void startMission(Cargo cargo) {
    if (_activeCargo != null) return;
    _activeCargo = cargo;
  }

  void completeMission() {
    _activeCargo = null;
  }

  void cancelMission() {
    _activeCargo = null;
  }
}
