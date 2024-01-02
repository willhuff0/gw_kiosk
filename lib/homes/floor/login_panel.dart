import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gw_kiosk/client/iv_client.dart';

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

  void _submit() {
    if (_valid && _password == ADMIN_PASSWORD) {
      widget.onLoggedIn();
    }
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
              onSubmitted: (value) {
                if (_valid) {}
              },
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
