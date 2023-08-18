import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gw_kiosk/client/iv_client.dart';
import 'package:gw_kiosk/data_stores/sysinfo_store.dart';
import 'package:window_manager/window_manager.dart';

class FloorHome extends StatefulWidget {
  const FloorHome({super.key});

  @override
  State<FloorHome> createState() => _FloorHomeState();
}

class _FloorHomeState extends State<FloorHome> {
  @override
  void initState() {
    windowManager.setFullScreen(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return const Dialog(
                    insetPadding: EdgeInsets.all(104.0),
                    child: AdminDialog(),
                  );
                },
              );
            },
            icon: const Icon(Icons.build),
          ),
          const SizedBox(width: 8.0),
        ],
      ),
    );
  }
}

class AdminDialog extends StatefulWidget {
  const AdminDialog({super.key});

  @override
  State<AdminDialog> createState() => _AdminDialogState();
}

class _AdminDialogState extends State<AdminDialog> {
  var _authenticated = true;
  var _page = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    _pages = [
      AdminDialogHome(
        key: GlobalKey(),
        onSelectSystemInformation: () => setState(() => _page = 1),
      ),
      SystemInformationPage(
        key: GlobalKey(),
        onBack: () => setState(() => _page = 0),
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _authenticated
        ? AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubicEmphasized,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _pages[_page],
            ),
          )
        : LoginPanel(
            onLoggedIn: () => setState(() => _authenticated = true),
          );
  }
}

class AdminDialogHome extends StatelessWidget {
  final void Function() onSelectSystemInformation;

  const AdminDialogHome({super.key, required this.onSelectSystemInformation});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 14.0, top: 14.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Admin Panel', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(width: 56.0),
              const IVClientIndicator(),
              const SizedBox(width: 24.0),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            children: [
              FilledButton.tonal(
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 14.0),
                  child: Text('System information'),
                ),
                onPressed: () {
                  onSelectSystemInformation();
                },
              ),
              const SizedBox(height: 8.0),
              FilledButton.tonal(
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 14.0),
                  child: Text('IVClient config'),
                ),
                onPressed: () {},
              ),
              const SizedBox(height: 8.0),
              FilledButton.tonal(
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 14.0),
                  child: Text('Show desktop'),
                ),
                onPressed: () {
                  windowManager.minimize();
                },
              ),
              const SizedBox(height: 36.0),
              FilledButton(
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
                  child: Text('Sell this PC'),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SystemInformationPage extends StatefulWidget {
  final void Function() onBack;

  const SystemInformationPage({super.key, required this.onBack});

  @override
  State<SystemInformationPage> createState() => _SystemInformationPageState();
}

class _SystemInformationPageState extends State<SystemInformationPage> {
  final _expanded = <int>{};

  void _expand(int index) {
    setState(() {
      if (!_expanded.add(index)) {
        _expanded.remove(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sysInfo = SysinfoStore.current!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18.0, top: 18.0, right: 18.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  widget.onBack();
                },
                icon: const Icon(Icons.chevron_left),
              ),
              const SizedBox(width: 8.0),
              const Text('System information'),
            ],
          ),
        ),
        // ExpansionPanelList(
        //   expansionCallback: (index, expanded) {
        //     _expand(index);
        //   },
        //   children: [
        //     ExpansionPanel(
        //       canTapOnHeader: true,
        //       isExpanded: _expanded.contains(0),
        //       headerBuilder: (context, expanded) {
        //         return Text('Processor', style: Theme.of(context).textTheme.labelLarge);
        //       },
        //       body: Card(
        //         child: Padding(
        //           padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
        //           child: Row(
        //             mainAxisSize: MainAxisSize.min,
        //             children: [
        //               const Column(
        //                 crossAxisAlignment: CrossAxisAlignment.end,
        //                 mainAxisSize: MainAxisSize.min,
        //                 children: [
        //                   Text('Name:'),
        //                   Text('Speed:'),
        //                   Text('Threads:'),
        //                   Text('Cores:'),
        //                 ],
        //               ),
        //               const Padding(
        //                 padding: EdgeInsets.all(4.0),
        //                 child: Divider(),
        //               ),
        //               Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 mainAxisSize: MainAxisSize.min,
        //                 children: [
        //                   Text(sysInfo.cpu.brand, style: const TextStyle(fontWeight: FontWeight.w500)),
        //                   Text('${sysInfo.cpu.speed} MHz'),
        //                   Text(sysInfo.cpu.cores),
        //                   Text(sysInfo.cpu.physicalCores),
        //                 ],
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     )
        //   ],
        // ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Wrap(
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
            ),
          ),
        ),
      ],
    );
  }
}

class LoginPanel extends StatefulWidget {
  final Function() onLoggedIn;

  const LoginPanel({super.key, required this.onLoggedIn});

  @override
  State<LoginPanel> createState() => _LoginPanelState();
}

class _LoginPanelState extends State<LoginPanel> {
  Timer? _changedTimer;

  String? _password;
  var _valid = false;

  void _onChanged(String value) {
    setState(() => _valid = false);
    _password = value;
    _changedTimer?.cancel();
    _changedTimer = Timer(const Duration(milliseconds: 600), _validate);
  }

  void _validate() {
    if (_password == null) return;
    if (_password!.isEmpty || _password!.length < 3) return;
    setState(() => _valid = true);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child: Container()),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 14.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(14.0)),
                filled: true,
                label: const Text('Password'),
              ),
              obscureText: true,
              autofocus: true,
              onChanged: _onChanged,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 42.0, top: 24.0),
            child: FilledButton(
              onPressed: _valid
                  ? () {
                      if (_password == ADMIN_PASSWORD) {
                        widget.onLoggedIn();
                      }
                    }
                  : null,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                child: Text('Log in'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
