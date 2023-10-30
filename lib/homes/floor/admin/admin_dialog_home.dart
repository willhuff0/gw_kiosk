import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gw_kiosk/client/iv_client.dart';
import 'package:gw_kiosk/homes/onboarding_home.dart';
import 'package:window_manager/window_manager.dart';

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
              // const SizedBox(height: 8.0),
              // FilledButton.tonal(
              //   child: const Padding(
              //     padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 14.0),
              //     child: Text('IVClient config'),
              //   ),
              //   onPressed: () {},
              // ),
              const SizedBox(height: 8.0),
              FilledButton.tonal(
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 14.0),
                  child: Text('Open Onboarding Log'),
                ),
                onPressed: () {
                  windowManager.minimize();
                  Process.start('notepad.exe', ['"$onboardingLogPath"']);
                },
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
                  child: Text('Close'),
                ),
                onPressed: () {
                  exit(0);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
