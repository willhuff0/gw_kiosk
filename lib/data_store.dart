import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

class GenericCreator<T> {
  final T Function() creator;

  GenericCreator(this.creator);

  T getGenericInstance() {
    return creator();
  }
}

abstract class DataStore {
  static String getStorePath(String store) => p.join(p.dirname(Platform.resolvedExecutable), 'data_store', '$store.json');

  final String store;

  DataStore(this.store);

  Map<String, dynamic> toMap();

  void fromMap(Map<String, dynamic> map);

  Future<void> save() async {
    final file = File(getStorePath(store));
    await file.create(recursive: true);

    final content = const JsonEncoder.withIndent('    ').convert(toMap());
    await file.writeAsString(content);
  }

  static Future<TDataStore?> read<TDataStore extends DataStore>(TDataStore Function() creator) async {
    final dataStore = creator();

    final file = File(getStorePath(dataStore.store));
    if (!await file.exists()) return null;

    final content = json.decode(await file.readAsString());
    dataStore.fromMap(content);

    return dataStore;
  }
}
