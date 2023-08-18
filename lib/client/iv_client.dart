// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

const ADMIN_PASSWORD = 'lockedtight';

class IVClient {
  static var error = false;

  static IVClient? current;
  static final StreamController<IVClient?> _ivClientChangedController = StreamController.broadcast();
  static final Stream<IVClient?> ivClientChanged = _ivClientChangedController.stream;

  static const SERVER_ADDRESS = '129.168.173.226';
  static const SERVER_PORT = 2311;

  final WebSocket socket;

  IVClient._(this.socket) {
    try {
      socket.listen(_handle);
    } finally {
      close();
    }
  }

  static Future<IVClient?> connect() async {
    try {
      error = false;
      _ivClientChangedController.add(null);
      await current?.close();
      current = null;

      final socket = await WebSocket.connect('ws://$SERVER_ADDRESS:$SERVER_PORT');

      current = IVClient._(socket);
      _ivClientChangedController.add(current);
      return current!;
    } catch (e) {
      error = true;
      _ivClientChangedController.add(null);
      return null;
    }
  }

  Future close() async {
    current = null;
    await socket.close();
  }

  void _handle(dynamic data) {}
}

class IVClientIndicator extends StatelessWidget {
  const IVClientIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: null,
      stream: IVClient.ivClientChanged,
      builder: (context, snapshot) {
        final ivClient = snapshot.data;

        if (IVClient.error) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  IVClient.connect();
                },
                tooltip: 'Retry',
                icon: const Icon(Icons.wifi_off),
              ),
              const SizedBox(width: 14.0),
              const Text('IVClient disconnected'),
            ],
          );
        } else if (ivClient == null) {
          return const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
              SizedBox(width: 14.0),
              Text('IVClient connecting...'),
            ],
          );
        } else {
          return const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wifi),
              SizedBox(width: 14.0),
              Text('IVClient connected'),
            ],
          );
        }
      },
    );
  }
}
