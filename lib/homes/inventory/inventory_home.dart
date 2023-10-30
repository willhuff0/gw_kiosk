import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gw_kiosk/data_stores/iv_store.dart';
import 'package:gw_kiosk/data_stores/sysinfo_store.dart';
import 'package:gw_kiosk/homes/inventory/info_sheets_view.dart';
import 'package:gw_kiosk/widgets/system_information_wrap.dart';

class InventoryHome extends StatefulWidget {
  const InventoryHome({super.key});

  @override
  State<InventoryHome> createState() => _InventoryHomeState();
}

class _InventoryHomeState extends State<InventoryHome> {
  final formKey = GlobalKey<FormState>();

  var changed = false;

  @override
  Widget build(BuildContext context) {
    final sysInfo = SysinfoStore.current!;
    final iv = IVStore.current!;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Inventory Mode'),
            const SizedBox(width: 32.0),
            Text('Unique ID: ', style: Theme.of(context).textTheme.labelMedium),
            Text(iv.uuid, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
      body: Row(
        children: [
          const Expanded(
            flex: 5,
            child: InfoSheetsView(),
          ),
          const VerticalDivider(),
          Expanded(
            flex: 3,
            child: Form(
              key: formKey,
              onChanged: () => setState(() => changed = true),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('This PC', style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 18.0),
                          const Divider(),
                          const SizedBox(height: 14.0),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Price',
                              prefixText: r'$ ',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}')),
                            ],
                            initialValue: iv.price.toStringAsFixed(2),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Cannot be blank';

                              final price = double.tryParse(value);
                              if (price == null) return 'Must be a number';

                              return null;
                            },
                            onSaved: (value) {
                              var price = double.parse(value!);
                              price = (price * 100).round() * 0.01;

                              iv.price = price;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FilledButton.tonalIcon(
                        icon: const Icon(Icons.save),
                        label: const Text('Save'),
                        onPressed: changed
                            ? () {
                                final form = formKey.currentState!;
                                if (form.validate()) {
                                  form.save();
                                  iv.save();

                                  setState(() => changed = false);
                                }
                              }
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
