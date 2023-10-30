import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gw_kiosk/data_store.dart';
import 'package:gw_kiosk/data_stores/sysinfo_store.dart';
import 'package:gw_kiosk/widgets/system_information_wrap.dart';
import 'package:window_manager/window_manager.dart';

class SystemInformationPage extends StatefulWidget {
  final void Function() onBack;

  const SystemInformationPage({super.key, required this.onBack});

  @override
  State<SystemInformationPage> createState() => _SystemInformationPageState();
}

class _SystemInformationPageState extends State<SystemInformationPage> {
  var refreshing = false;

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
              const SizedBox(width: 8.0),
              FilledButton.tonalIcon(
                onPressed: refreshing
                    ? null
                    : () {
                        final path = DataStore.getStorePath(sysInfo.store);
                        windowManager.minimize();
                        Process.start('notepad.exe', ['"$path"']);
                      },
                icon: const Icon(Icons.edit),
                label: const Text('Edit'),
              ),
              const SizedBox(width: 8.0),
              FilledButton.tonalIcon(
                onPressed: refreshing
                    ? null
                    : () async {
                        if (await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Are you sure?'),
                                content: const Text('Refreshing will override manual changes to the spec list.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                    child: const Text('Refresh'),
                                  ),
                                  FilledButton.tonal(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                ],
                              );
                            })) {
                          setState(() => refreshing = true);
                          await sysInfo.refresh();
                          setState(() => refreshing = false);
                        }
                      },
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: SystemInformationWrap(sysInfo: sysInfo),
          ),
        ),
      ],
    );
  }
}
