import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gw_kiosk/client/iv_client.dart';
import 'package:gw_kiosk/data_store.dart';
import 'package:gw_kiosk/data_stores/onboarding_store.dart';
import 'package:gw_kiosk/main.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

final onboardingLogPath = p.join(p.dirname(Platform.resolvedExecutable), 'data_store', 'onboarding.log');

Future<bool> _checkForInternet() async {
  return await http.get(Uri.parse('https://www.google.com/')).then((value) => true).catchError((e) => false).timeout(const Duration(seconds: 5), onTimeout: () => false);
}

class OnboardingHomePage extends StatefulWidget {
  final void Function() onComplete;

  const OnboardingHomePage({super.key, required this.onComplete});

  @override
  State<OnboardingHomePage> createState() => _OnboardingHomePageState();
}

class _OnboardingHomePageState extends State<OnboardingHomePage> {
  late final StreamController<List<int>> _consoleController;
  late final OnboardingStore _store;
  var loading = true;
  late bool hasInternet;
  var step = 0;

  @override
  void initState() {
    _consoleController = StreamController<List<int>>.broadcast();
    start();
    super.initState();
  }

  void start() async {
    if (await _checkForInternet()) {
      hasInternet = true;
      run();
    } else {
      setState(() {
        loading = false;
        hasInternet = false;
      });
    }
  }

  void run() async {
    final logFile = await File(onboardingLogPath).create(recursive: true);
    _consoleController.stream.pipe(logFile.openWrite());
    _store = await DataStore.read<OnboardingStore>(OnboardingStore.creator) ?? OnboardingStore.empty();
    setState(() {
      loading = false;
      step = 0;
    });

    devModeProcess() async => await Process.start('powershell.exe', ['-Command', 'Start-Sleep 2; Write-Output "DEV_MODE flag enabled, this is a blank process."']);

    if (!_store.setPowerConfig) {
      if (!DEV_MODE) await Process.run('powershell.exe', ['-Command', r'powercfg /X monitor-timeout-ac 0']);
      if (!DEV_MODE) await Process.run('powershell.exe', ['-Command', r'powercfg /X standby-timeout-ac 0']);
      _store.setPowerConfig = true;
      await _store.save();
    }

    if (!_store.chocoInstalled) {
      setState(() => step = 1);
      var process = DEV_MODE ? await devModeProcess() : await Process.start('powershell.exe', ['-Command', r"Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"]);
      await _consoleController.addStream(process.stdout);
      setState(() => _store.chocoInstalled = true);
      await _store.save();
    }

    if (!_store.choco_firefox) {
      setState(() => step = 1);
      var process = DEV_MODE ? await devModeProcess() : await Process.start('powershell.exe', ['-Command', 'choco install firefox -y']);
      await _consoleController.addStream(process.stdout);
      setState(() => _store.choco_firefox = true);
      await _store.save();
    }
    if (!_store.choco_adobereader) {
      step = 1;
      var process = DEV_MODE ? await devModeProcess() : await Process.start('powershell.exe', ['-Command', 'choco install adobereader -y']);
      await _consoleController.addStream(process.stdout);
      setState(() => _store.choco_adobereader = true);
      await _store.save();
    }
    if (!_store.choco_vlc) {
      setState(() => step = 1);
      // var process = DEV_MODE ? await devModeProcess() : await Process.start('powershell.exe', ['-Command', 'choco install vlc -y']);
      var process = await Process.start('powershell.exe', ['-Command', 'choco install vlc -y']);
      await _consoleController.addStream(process.stdout);
      setState(() => _store.choco_vlc = true);
      await _store.save();
    }
    if (!_store.choco_libreoffice) {
      setState(() => step = 1);
      var process = DEV_MODE ? await devModeProcess() : await Process.start('powershell.exe', ['-Command', 'choco install libreoffice-still -y']);
      await _consoleController.addStream(process.stdout);
      setState(() => _store.choco_libreoffice = true);
      await _store.save();
    }

    if (!_store.updatePackageInstalled) {
      setState(() => step = 2);
      var process = DEV_MODE ? await devModeProcess() : await Process.start('powershell.exe', ['-Command', 'Install-PackageProvider -Name NuGet -Force']);
      await _consoleController.addStream(process.stdout);
      process = DEV_MODE ? await devModeProcess() : await Process.start('powershell.exe', ['-Command', 'Install-Module -Name PSWindowsUpdate -Force']);
      await _consoleController.addStream(process.stdout);
      setState(() => _store.updatePackageInstalled = true);
      await _store.save();
    }
    if (!_store.updatesStarted || _store.updateIterations < 10) {
      setState(() {
        step = 2;
        _store.updatesStarted = true;
        _store.updateIterations++;
      });
      await _store.save();

      var process = DEV_MODE ? await devModeProcess() : await Process.start('powershell.exe', ['-Command', 'Get-WindowsUpdate -AcceptAll -Install -AutoReboot']);
      await _consoleController.addStream(process.stdout);
    }
    if (!_store.updatesComplete) {
      setState(() => step = 2);
      //var process = DEV_MODE ? await devModeProcess() : await Process.start('powershell.exe', ['-Command', 'choco install libreoffice-still -y']);
      //await _consoleController.addStream(process.stdout );
      setState(() => _store.updatesComplete = true);
      await _store.save();
    }

    if (!_store.initializedAllDisks) {
      setState(() => step = 3);
      setState(() => _store.initializedAllDisks = true);
      await _store.save();
    }

    if (!_store.uacEnabled) {
      setState(() => step = 4);
      var process = DEV_MODE ? await devModeProcess() : await Process.start('powershell.exe', ['-Command', r'Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value "5"']);
      await _consoleController.addStream(process.stdout);
      process = DEV_MODE ? await devModeProcess() : await Process.start('powershell.exe', ['-Command', r'Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "PromptOnSecureDesktop" -Value "1"']);
      await _consoleController.addStream(process.stdout);
      setState(() => _store.uacEnabled = true);
      await _store.save();
    }

    if (!_store.cleanedUp) {
      setState(() => step = 4);
      // var process = DEV_MODE ? await devModeProcess() : await Process.start('powershell.exe', ['-Command', r'Remove-Item C:\Windows\Setup\Automation -Force -Recurse']);
      // await _consoleController.addStream(process.stdout );
      var process = DEV_MODE ? await devModeProcess() : await Process.start('powershell.exe', ['-Command', r'Set-ExecutionPolicy Restricted -Scope LocalMachine -Force']);
      await _consoleController.addStream(process.stdout);
      setState(() => _store.cleanedUp = true);
      await _store.save();
    }

    _consoleController.close();
    widget.onComplete();
  }

  @override
  void dispose() {
    _consoleController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Onboarding'),
        flexibleSpace: const Padding(
          padding: EdgeInsets.only(right: 18.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: IVClientIndicator(),
          ),
        ),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : hasInternet
              ? Row(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 18.0),
                        children: [
                          OnboardingStep(
                            name: 'Install Bloatware',
                            complete: _store.chocoInstalled && _store.choco_firefox && _store.choco_adobereader && _store.choco_vlc && _store.choco_libreoffice,
                            inProgress: step == 1,
                            subSteps: [
                              OnboardingSubStep(name: 'Get Choco', complete: _store.chocoInstalled),
                              OnboardingSubStep(name: 'Install FireFox', complete: _store.choco_firefox),
                              OnboardingSubStep(name: 'Install AdobeReader', complete: _store.choco_adobereader),
                              OnboardingSubStep(name: 'Install VLC', complete: _store.choco_vlc),
                              OnboardingSubStep(name: 'Install LibreOffice', complete: _store.choco_libreoffice),
                            ],
                          ),
                          const SizedBox(height: 14.0),
                          OnboardingStep(
                            name: 'Windows Updates',
                            complete: _store.updatesComplete,
                            inProgress: step == 2,
                            subSteps: [
                              OnboardingSubStep(name: 'Install PSWindowsUpdate', complete: _store.updatePackageInstalled),
                              OnboardingSubStep(name: 'Get updates and drivers availible to install', complete: _store.updatesStarted),
                              OnboardingSubStep(name: 'Install updates (PC will restart, iteration: ${_store.updateIterations})', complete: _store.updatesComplete),
                            ],
                          ),
                          const SizedBox(height: 14.0),
                          OnboardingStep(
                            name: 'Disks',
                            complete: _store.initializedAllDisks,
                            inProgress: step == 3,
                            subSteps: [
                              OnboardingSubStep(name: 'Initialize all disks', complete: _store.initializedAllDisks),
                            ],
                          ),
                          const SizedBox(height: 14.0),
                          OnboardingStep(
                            name: 'Cleanup',
                            complete: _store.uacEnabled && _store.cleanedUp,
                            inProgress: step == 4,
                            subSteps: [
                              OnboardingSubStep(name: 'Enable UAC', complete: _store.uacEnabled),
                              OnboardingSubStep(name: 'Clean up', complete: _store.cleanedUp),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 18.0,
                          left: 8.0,
                          right: 18.0,
                          bottom: 18.0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: SizedBox.expand(
                            child: ConsoleView(stream: _consoleController.stream),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : WaitingForInternetPage(onHasInternet: () {
                  setState(() {
                    loading = true;
                    hasInternet = true;
                  });
                  run();
                }),
    );
  }
}

class OnboardingSubStep {
  final String name;
  final bool complete;

  const OnboardingSubStep({required this.name, required this.complete});
}

class OnboardingStep extends StatelessWidget {
  final String name;
  final bool complete;
  final bool inProgress;
  final List<OnboardingSubStep> subSteps;

  const OnboardingStep({super.key, required this.name, required this.complete, required this.inProgress, required this.subSteps});

  @override
  Widget build(BuildContext context) {
    var lastComplete = inProgress;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 600),
      opacity: complete
          ? 0.2
          : inProgress
              ? 1.0
              : 0.8,
      child: Card(
        elevation: complete
            ? 1.0
            : inProgress
                ? 4.0
                : 2.0,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 18.0,
                    height: 18.0,
                    child: complete
                        ? const Icon(Icons.check, size: 18.0)
                        : inProgress
                            ? const Icon(Icons.circle, size: 6.0)
                            : const Icon(Icons.circle_outlined, size: 6.0),
                  ),
                  const SizedBox(width: 14.0),
                  Text(name, style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
              const SizedBox(height: 14.0),
              ...subSteps.map(
                (subStep) {
                  var isInProgress = lastComplete;
                  lastComplete = subStep.complete;
                  return ListTile(
                    dense: true,
                    visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                    title: Text(subStep.name),
                    leading: SizedBox(
                      width: 18.0,
                      height: 18.0,
                      child: subStep.complete
                          ? const Icon(Icons.check, size: 18.0)
                          : isInProgress
                              ? const CircularProgressIndicator(strokeWidth: 2.5)
                              : const Icon(Icons.circle_outlined, size: 6.0),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConsoleView extends StatefulWidget {
  final Stream<List<int>> stream;

  const ConsoleView({super.key, required this.stream});

  @override
  State<ConsoleView> createState() => _ConsoleViewState();
}

class _ConsoleViewState extends State<ConsoleView> {
  late final StreamSubscription _subscription;
  var _value = '';
  var _carriageReturn = false;

  @override
  void initState() {
    _subscription = widget.stream.listen((event) {
      for (var binaryCharacter in event) {
        final character = String.fromCharCode(binaryCharacter);

        if (_carriageReturn) {
          if (character != '\n') {
            _value = _value.substring(0, _value.lastIndexOf('\n'));
            _value += '\n';
          }
          _carriageReturn = false;
        } else if (character == '\r') {
          _carriageReturn = true;
          continue;
        }

        _value += character;
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
      child: Text(_value, style: const TextStyle(color: Colors.white)),
    );
  }
}

class WaitingForInternetPage extends StatefulWidget {
  final VoidCallback onHasInternet;

  const WaitingForInternetPage({super.key, required this.onHasInternet});

  @override
  State<WaitingForInternetPage> createState() => _WaitingForInternetPageState();
}

class _WaitingForInternetPageState extends State<WaitingForInternetPage> {
  var _countdown = 5;

  @override
  void initState() {
    run();
    super.initState();
  }

  void run() async {
    while (true) {
      if (!mounted) return;
      if (_countdown == 0) {
        if (await _checkForInternet()) {
          widget.onHasInternet();
          return;
        }
        setState(() => _countdown = 5);
      } else {
        await Future.delayed(const Duration(seconds: 1));
        setState(() => _countdown--);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Waiting for internet...\nTrying again in $_countdown', textAlign: TextAlign.center),
          const SizedBox(height: 8.0),
          FilledButton.tonal(
              onPressed: () {
                widget.onHasInternet();
              },
              child: const Text('Continue Anyway')),
        ],
      ),
    );
  }
}
