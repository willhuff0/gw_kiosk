import 'package:gw_kiosk/data_store.dart';

final class IVStore extends DataStore {
  late final String uuid;

  IVStore.creator() : super('iv');

  IVStore.empty() : super('iv');

  @override
  void fromMap(Map<String, dynamic> map) {
    // TODO: implement fromMap
  }

  @override
  Map<String, dynamic> toMap() => {
        'notImplemented': '',
      };
}
