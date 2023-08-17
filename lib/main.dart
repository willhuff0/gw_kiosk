import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gw_kiosk/client/iv_client.dart';
import 'package:gw_kiosk/data_store.dart';
import 'package:gw_kiosk/data_stores/phase_store.dart';
import 'package:gw_kiosk/data_stores/sysinfo_store.dart';
import 'package:gw_kiosk/homes/onboarding_home.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();
  const windowOptions = WindowOptions();
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setPreventClose(true);
  });

  launchAtStartup.setup(
    appName: 'Goodwill Kiosk',
    appPath: Platform.resolvedExecutable,
  );

  await launchAtStartup.enable();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue.shade700,
          brightness: Brightness.dark,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _loading = true;
  late PhaseStore _phase;

  var _loadingSysInfo = true;
  late SysinfoStore _sysinfo;

  @override
  void initState() {
    loadStores();
    super.initState();
  }

  void loadStores() async {
    IVClient.connect();

    _phase = await DataStore.read<PhaseStore>(PhaseStore.creator) ?? PhaseStore.empty();

    setState(() {
      _loading = false;
    });

    //_sysinfo = await DataStore.read<SysinfoStore>(SysinfoStore.creator) ?? SysinfoStore.empty();
    _sysinfo = SysinfoStore.empty();
    await _sysinfo.refresh();

    setState(() {
      _loadingSysInfo = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const LoadingPage()
        : _loadingSysInfo
            ? const LoadingPage(label: 'Refreshing system information')
            : switch (_phase.phase) {
                Phase.onboarding => const OnboardingHomePage(),
                _ => Container(),
              };
  }
}

class LoadingPage extends StatelessWidget {
  final String label;

  const LoadingPage({super.key, this.label = 'Loading'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const Padding(
          padding: EdgeInsets.only(right: 18.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: IVClientIndicator(),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            const SizedBox(height: 14.0),
            const SizedBox(
              width: 200.0,
              child: LinearProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}