import 'package:collection/collection.dart';
import 'package:curved_gradient/curved_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gw_kiosk/data_stores/sysinfo_store.dart';
import 'package:gw_kiosk/homes/floor/admin/admin_dialog.dart';
import 'package:gw_kiosk/main.dart';
import 'package:window_manager/window_manager.dart';
import 'package:window_size/window_size.dart';

class FloorHome extends StatefulWidget {
  const FloorHome({super.key});

  @override
  State<FloorHome> createState() => _FloorHomeState();
}

class _FloorHomeState extends State<FloorHome> {
  late final GlobalKey _extendedLogoKey;
  late final GlobalKey _compactLogoKey;

  Widget _getExtendedLogo(SysinfoStore sysInfo) {
    return Positioned(
      key: _extendedLogoKey,
      left: 64.0,
      bottom: -64.0,
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/logos/windows_${sysInfo.os.distro.contains('11') ? '11' : '10'}_logo.svg',
            width: 456.0,
          ),
          const SizedBox(width: 48.0),
          const SizedBox(height: 48.0, child: VerticalDivider()),
          const SizedBox(width: 4.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(sysInfo.system.model, style: Theme.of(context).textTheme.headlineSmall),
              Text(sysInfo.system.manufacturer, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getCompactLogo(SysinfoStore sysInfo) {
    return Positioned(
      key: _compactLogoKey,
      left: 64.0,
      bottom: -64.0,
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/logos/windows_${sysInfo.os.distro.contains('11') ? '11' : '10'}_logo.svg',
            width: 456.0,
          ),
          const SizedBox(width: 48.0),
          const SizedBox(height: 48.0, child: VerticalDivider()),
          const SizedBox(width: 4.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(sysInfo.system.model, style: Theme.of(context).textTheme.headlineSmall),
              Text(sysInfo.system.manufacturer, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    _extendedLogoKey = GlobalKey();
    _compactLogoKey = GlobalKey();
    setWindow();
    super.initState();
  }

  void setWindow() async {
    //await Window.setEffect(effect: WindowEffect.acrylic, dark: false);
    //await Window.hideWindowControls();
    await windowManager.setSkipTaskbar(true);
    await windowManager.setResizable(false);
    await windowManager.setAlwaysOnTop(true);
    //await windowManager.setHasShadow(false);
    //await windowManager.setAsFrameless();
    //await windowManager.setBackgroundColor(Colors.transparent);
    setWindowFrame(Rect.fromLTRB(14.0, 14.0, screen.frame.right / 2.2, screen.frame.bottom - 14.0));
  }

  @override
  Widget build(BuildContext context) {
    final sysInfo = SysinfoStore.current!;

    return Scaffold(
      //backgroundColor: Colors.white.withOpacity(0.4),
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
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
                icon: Icon(Icons.build, color: Theme.of(context).colorScheme.onBackground.withOpacity(0.4)),
              ),
              const SizedBox(width: 8.0),
            ],
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  fit: StackFit.expand,
                  clipBehavior: Clip.none,
                  children: [
                    ShaderMask(
                      shaderCallback: (rect) {
                        return CurvedGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black],
                          stops: [0.4, 1.0],
                          granularity: 10,
                          curveGenerator: (x) => Curves.easeInOut.transform(x),
                        ).createShader(Rect.fromLTRB(0.0, 0.0, rect.top, rect.bottom));
                      },
                      blendMode: BlendMode.dstIn,
                      child: Image.asset(
                        'assets/backgrounds/windows_${Theme.of(context).colorScheme.brightness == Brightness.light ? 'light' : 'dark'}.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      key: _extendedLogoKey,
                      left: 64.0,
                      bottom: -64.0,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 100),
                        opacity: constraints.maxHeight > 100.0 ? 1.0 : 0.0,
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/logos/windows_${sysInfo.os.distro.contains('11') ? '11' : '10'}_logo.svg',
                              width: 456.0,
                            ),
                            const SizedBox(width: 48.0),
                            const SizedBox(height: 48.0, child: VerticalDivider()),
                            const SizedBox(width: 4.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(sysInfo.system.model, style: Theme.of(context).textTheme.headlineSmall),
                                Text(sysInfo.system.manufacturer, style: Theme.of(context).textTheme.bodyLarge),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 100),
                      opacity: constraints.maxHeight <= 100.0 ? 1.0 : 0.0,
                      child: Row(
                        children: [
                          const SizedBox(width: 36.0),
                          SvgPicture.asset(
                            'assets/logos/windows_${sysInfo.os.distro.contains('11') ? '11' : '10'}_logo.svg',
                            height: 36.0,
                          ),
                          const SizedBox(width: 36.0),
                          const SizedBox(height: 36.0, child: VerticalDivider()),
                          const SizedBox(width: 8.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(sysInfo.system.model, style: Theme.of(context).textTheme.titleMedium),
                              Text(sysInfo.system.manufacturer, style: Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            expandedHeight: 550.0,
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 56.0)),
          SliverPadding(
            padding: const EdgeInsets.all(48.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Specs', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 2.0),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
                    child: Wrap(
                      spacing: 24.0,
                      runSpacing: 24.0,
                      direction: Axis.horizontal,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Processor', style: Theme.of(context).textTheme.labelLarge),
                            const SizedBox(height: 4.0),
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
                                        Text('${((double.parse(sysInfo.cpu.speed) / 10).floor() / 100).toStringAsFixed(2)} GHz'),
                                        Text(sysInfo.cpu.cores),
                                        Text(sysInfo.cpu.physicalCores),
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
                            const SizedBox(height: 4.0),
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
                            const SizedBox(height: 4.0),
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
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    if (memory.bank.isNotEmpty) const Text('Bank:'),
                                                    const Text('Size:'),
                                                    const Text('Speed:'),
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
                                                    if (memory.bank.isNotEmpty) Text(memory.bank),
                                                    Text('${memory.size / (1024 * 1024 * 1024)} GB'),
                                                    Text('${memory.clockSpeed.toString()} MHz'),
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
                            const SizedBox(height: 4.0),
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
                            const SizedBox(height: 4.0),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: sysInfo.network.foldIndexed(
                                    <Widget>[],
                                    (index, value, network) {
                                      if (network.virtual == false) return value;
                                      value.add(
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (value.isNotEmpty) const SizedBox(width: 56.0, child: Divider()),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    const Text('Name:'),
                                                    if (network.type.isNotEmpty) const Text('Type:'),
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
                                                    if (network.type.isNotEmpty) Text(network.type),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                      return value;
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
                ],
              ),
            ),
          ),
          const SliverFillRemaining(
            fillOverscroll: true,
          ),
        ],
      ),
    );
  }
}
