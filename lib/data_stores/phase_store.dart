import 'package:gw_kiosk/data_store.dart';

final class PhaseStore extends DataStore {
  late Phase phase;

  PhaseStore.creator() : super('phase');

  PhaseStore.empty() : super('phase') {
    phase = Phase.onboarding;
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    phase = Phase.values[(int.tryParse(map['phase']) ?? 0)];
  }

  @override
  Map<String, dynamic> toMap() => {
        'phase': phase.index.toString(),
      };
}

enum Phase {
  onboarding,
  inventory,
  floor,
  sold,
}
