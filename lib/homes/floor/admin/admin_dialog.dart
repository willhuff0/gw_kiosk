import 'package:flutter/material.dart';
import 'package:gw_kiosk/homes/floor/admin/admin_dialog_home.dart';
import 'package:gw_kiosk/homes/floor/admin/system_information_page.dart';
import 'package:gw_kiosk/homes/floor/login_panel.dart';

class AdminDialog extends StatefulWidget {
  const AdminDialog({super.key});

  @override
  State<AdminDialog> createState() => _AdminDialogState();
}

class _AdminDialogState extends State<AdminDialog> {
  var _authenticated = false;
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
