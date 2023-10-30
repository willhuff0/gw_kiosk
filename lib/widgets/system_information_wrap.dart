import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gw_kiosk/data_stores/sysinfo_store.dart';

class SystemInformationWrap extends StatelessWidget {
  const SystemInformationWrap({
    super.key,
    required this.sysInfo,
  });

  final SysinfoStore sysInfo;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      // mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 14.0,
      runSpacing: 14.0,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('OS', style: Theme.of(context).textTheme.labelLarge),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Name:'),
                        Text('Arch:'),
                        Text('Build:'),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Divider(),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(sysInfo.os.distro, style: const TextStyle(fontWeight: FontWeight.w500)),
                        Text(sysInfo.os.arch),
                        Text(sysInfo.os.build),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Motherboard', style: Theme.of(context).textTheme.labelLarge),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Name:'),
                        Text('Brand:'),
                        Text('Version:'),
                        Text('Date:'),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Divider(),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(sysInfo.system.model, style: const TextStyle(fontWeight: FontWeight.w500)),
                        Text(sysInfo.system.manufacturer),
                        Text(sysInfo.bios.version),
                        Text(sysInfo.bios.releaseDate),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Processor', style: Theme.of(context).textTheme.labelLarge),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Name:'),
                        Text('Speed:'),
                        Text('Threads:'),
                        Text('Cores:'),
                        Text('Socket:'),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Divider(),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(sysInfo.cpu.brand, style: const TextStyle(fontWeight: FontWeight.w500)),
                        Text('${sysInfo.cpu.speed} MHz'),
                        Text(sysInfo.cpu.cores),
                        Text(sysInfo.cpu.physicalCores),
                        Text(sysInfo.cpu.socket),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Graphics', style: Theme.of(context).textTheme.labelLarge),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: sysInfo.graphics.controllers.mapIndexed(
                    (index, gpu) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index != 0) const SizedBox(width: 56.0, child: Divider()),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Name:'),
                                  Text('VRAM:'),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Divider(),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(gpu.model, style: const TextStyle(fontWeight: FontWeight.w500)),
                                  Text('${gpu.vram.toStringAsFixed(0)} MB'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Memory', style: Theme.of(context).textTheme.labelLarge),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Total capacity: '),
                        Text(
                          '${sysInfo.memory.fold(0, (previousValue, element) => previousValue + element.size) / (1024 * 1024 * 1024)} GB',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 56.0, child: Divider()),
                    ...sysInfo.memory.mapIndexed(
                      (index, memory) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (index != 0) const SizedBox(width: 56.0, child: Divider()),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Bank:'),
                                    Text('Size:'),
                                    Text('Speed:'),
                                    Text('Voltage:'),
                                    Text('Type:'),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Divider(),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(memory.bank),
                                    Text('${memory.size / (1024 * 1024 * 1024)} GB'),
                                    Text('${memory.clockSpeed.toString()} MHz'),
                                    Text('${(memory.voltageConfigured / 1000).toString()} V'),
                                    Text(memory.type),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Disks', style: Theme.of(context).textTheme.labelLarge),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: sysInfo.disks.mapIndexed(
                    (index, disk) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index != 0) const SizedBox(width: 56.0, child: Divider()),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Name:'),
                                  Text('Size:'),
                                  Text('Type:'),
                                  Text('Interface:'),
                                  Text('Status:'),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Divider(),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(disk.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                                  Text('${(disk.size / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB'),
                                  Text(disk.type),
                                  Text(disk.interfaceType),
                                  Text(disk.smartStatus),
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Network', style: Theme.of(context).textTheme.labelLarge),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: sysInfo.network.mapIndexed(
                    (index, network) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index != 0) const SizedBox(width: 56.0, child: Divider()),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Name:'),
                                  Text('Brand:'),
                                  Text('Type:'),
                                  Text('Virtual:'),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Divider(),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(network.ifaceName, style: const TextStyle(fontWeight: FontWeight.w500)),
                                  Text(network.manufactruer),
                                  Text(network.type),
                                  Text((!network.virtual).toString()),
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
