import 'package:flutter/material.dart';
import 'package:gw_kiosk/data_stores/sysinfo_store.dart';
import 'package:gw_kiosk/widgets/system_information_wrap.dart';

class InfoSheetsView extends StatefulWidget {
  const InfoSheetsView({super.key});

  @override
  State<InfoSheetsView> createState() => _InfoSheetsViewState();
}

class _InfoSheetsViewState extends State<InfoSheetsView> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sysInfo = SysinfoStore.current!;

    return Column(
      children: [
        TabBar.secondary(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Specifications'),
            Tab(text: 'Benchmarks'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: SystemInformationWrap(sysInfo: sysInfo),
              ),
              const SingleChildScrollView(
                padding: EdgeInsets.all(24.0),
                child: Text('Not implemented'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
