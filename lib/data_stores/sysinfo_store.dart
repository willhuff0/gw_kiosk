import 'package:gw_kiosk/data_store.dart';

import 'package:windows_system_info/windows_system_info.dart';

final class SysinfoStore extends DataStore {
  late final BaseBoardInfo baseBoard;
  late final CpuInfo cpu;
  late final GraphicsInfo graphics;
  late final List<MemoryInfo> memory;
  late final List<NetworkInfo> network;
  late final List<DiskLayoutInfo> disks;
  late final OsInfo os;

  SysinfoStore.creator() : super('sysinfo');

  SysinfoStore.empty() : super('sysinfo');

  Future<void> refresh() async {
    await WindowsSystemInfo.initWindowsInfo();
    final info = WindowsSystemInfo.windowsSystemInformation!;

    baseBoard = info.baseBoard;
    cpu = info.cpu;
    graphics = info.graphicsInfo;
    memory = info.memories;
    network = info.network;
    disks = info.disks;
    os = info.os;

    await save();
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    // TODO: implement fromMap
  }

  @override
  Map<String, dynamic> toMap() => {
        'notImplemented': '',
      };
}
