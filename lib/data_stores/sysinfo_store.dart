import 'package:gw_kiosk/data_store.dart';

import 'package:windows_system_info/windows_system_info.dart';

final class SysinfoStore extends DataStore {
  static SysinfoStore? current;

  late final OsInfo os;
  late final SystemInfo system;
  late final BiosInfo bios;
  late final CpuInfo cpu;
  late final GraphicsInfo graphics;
  late final List<MemoryInfo> memory;
  late final List<NetworkInfo> network;
  late final List<DiskLayoutInfo> disks;

  SysinfoStore.creator() : super('sysinfo');

  SysinfoStore.empty() : super('sysinfo');

  Future<void> refresh() async {
    await WindowsSystemInfo.initWindowsInfo();
    final info = WindowsSystemInfo.windowsSystemInformation!;

    os = info.os;
    system = info.system;
    bios = info.bios;
    cpu = info.cpu;
    graphics = info.graphicsInfo;
    memory = info.memories;
    network = info.network;
    disks = info.disks;

    await save();
    current = this;
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    os = OsInfo(
      arch: map['os']['arch'],
      build: map['os']['build'],
      distro: map['os']['name'],
      hostname: '',
      serial: '',
      uuid: '',
    );
    system = SystemInfo(
      manufacturer: map['motherboard']['brand'],
      model: map['motherboard']['name'],
      serial: '',
      sku: '',
      uuid: '',
      version: '',
    );
    bios = BiosInfo(
      releaseDate: map['motherboard']['date'],
      vendor: '',
      version: map['motherboard']['version'],
    );
    cpu = CpuInfo(
      brand: map['processor']['name'],
      cores: map['processor']['threads'],
      family: '',
      manufacturer: '',
      model: '',
      physicalCores: map['processor']['cores'],
      revision: '',
      socket: map['processor']['socket'],
      speed: map['processor']['speed'],
      stepping: '',
      vendor: '',
    );
    graphics = GraphicsInfo(
      controllers: (map['graphics'] as List)
          .map((gpu) => Controller(
                bus: '',
                model: gpu['name'],
                vendor: '',
                vram: gpu['vram'],
                vramDynamic: false,
              ))
          .toList(),
      displays: const [],
    );
    memory = (map['memory'] as List)
        .map((memory) => MemoryInfo(
              bank: memory['bank'],
              clockSpeed: memory['speed'],
              formFactor: '',
              manufacturer: '',
              partNum: '',
              serialNum: '',
              size: memory['size'],
              type: memory['type'],
              voltageConfigured: memory['voltage'],
              voltageMax: 0,
              voltageMin: 0,
            ))
        .toList();
    disks = (map['disks'] as List)
        .map((disk) => DiskLayoutInfo(
              bytesPerSector: 0,
              device: '',
              firmwareRevision: '',
              interfaceType: disk['interface'],
              name: disk['name'],
              sectorsPerTrack: 0,
              serialNum: '',
              size: disk['size'],
              smartStatus: disk['status'],
              totalCylinders: 0,
              totalHeads: 0,
              totalSectors: 0,
              totalTracks: 0,
              tracksPerCylinder: 0,
              type: disk['type'],
            ))
        .toList();
    network = (map['network'] as List)
        .map((network) => NetworkInfo(
              manufactruer: network['brand'],
              iface: '',
              ifaceName: network['name'],
              mac: '',
              type: network['type'],
              virtual: network['physical'],
            ))
        .toList();
  }

  @override
  Map<String, dynamic> toMap() => {
        'os': {
          'name': os.distro,
          'arch': os.arch,
          'build': os.build,
        },
        'motherboard': {
          'name': system.model,
          'brand': system.manufacturer,
          'version': bios.version,
          'date': bios.releaseDate,
        },
        'processor': {
          'name': cpu.brand,
          'speed': cpu.speed,
          'threads': cpu.cores,
          'cores': cpu.physicalCores,
          'socket': cpu.socket,
        },
        'graphics': graphics.controllers
            .map((gpu) => {
                  'name': gpu.model,
                  'vram': gpu.vram,
                })
            .toList(),
        'memory': memory
            .map((memory) => {
                  'bank': memory.bank,
                  'size': memory.size,
                  'speed': memory.clockSpeed,
                  'voltage': memory.voltageConfigured,
                  'type': memory.type,
                })
            .toList(),
        'disks': disks
            .map((disk) => {
                  'name': disk.name,
                  'size': disk.size,
                  'type': disk.type,
                  'interface': disk.interfaceType,
                  'status': disk.smartStatus,
                })
            .toList(),
        'network': network
            .map((network) => {
                  'name': network.ifaceName,
                  'brand': network.manufactruer,
                  'type': network.type,
                  'physical': network.virtual,
                })
            .toList(),
      };
}
