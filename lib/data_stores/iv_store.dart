import 'package:gw_kiosk/data_store.dart';
import 'package:uuid/uuid.dart';

final class IVStore extends DataStore {
  static IVStore? current;

  late final String uuid;
  late double price;

  IVStore.creator() : super('iv');

  IVStore.empty() : super('iv');

  void refreshAndCreateNew() {
    uuid = const Uuid().v4();
    price = 99.99;

    current = this;
    save();
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    uuid = map['uuid'];
    price = double.tryParse(map['price']) ?? 99.99;

    current = this;
  }

  @override
  Map<String, dynamic> toMap() => {
        'uuid': uuid,
        'price': price.toStringAsFixed(2),
      };
}
