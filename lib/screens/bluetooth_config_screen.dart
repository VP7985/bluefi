import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bluetooth_controller.dart';
import '../widgets/custom_text_field.dart';
import 'qr_scanner_screen.dart';

class BluetoothConfigScreen extends StatelessWidget {
  const BluetoothConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BluetoothController controller = Get.put(BluetoothController());

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Obx(() => Text(controller.isWifiMode.value
              ? 'WiFi Configurator'
              : 'Bluetooth Configurator')),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.offAllNamed('/wifi'),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Obx(() => controller.isWifiMode.value
                  ? FilledButton(
                      onPressed: () => Get.to(() => const QrScannerScreen()),
                      child: const Text('Scan WiFi QR Code'),
                    )
                  : FilledButton(
                      onPressed: controller.scanDevices,
                      child: const Text('Scan Devices'),
                    )),
              const SizedBox(height: 16),
              Obx(() => controller.isWifiMode.value
                  ? const SizedBox.shrink()
                  : controller.isScanning.value
                      ? const CircularProgressIndicator()
                      : Expanded(
                          child: ListView.builder(
                            itemCount: controller.devices.length,
                            itemBuilder: (context, index) {
                              final device = controller.devices[index];
                              return Card(
                                child: ListTile(
                                  title: Text(device.name.isEmpty ? 'Unknown Device' : device.name),
                                  subtitle: Text(device.id.toString()),
                                  trailing: Obx(() => Radio(
                                        value: device,
                                        groupValue: controller.selectedDevice.value,
                                        onChanged: (value) => controller.selectDevice(value!),
                                      )),
                                ),
                              );
                            },
                          ),
                        )),
              const SizedBox(height: 16),
              CustomTextField(
                controller: controller.ssidController,
                label: 'WiFi SSID',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: controller.passwordController,
                label: 'WiFi Password',
                obscureText: true,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: controller.ipController,
                label: 'Static IP Address',
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: controller.sendConfiguration,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('Send Configuration'),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: controller.toggleMode,
          child: Obx(() => Icon(
                controller.isWifiMode.value ? Icons.bluetooth : Icons.wifi,
              )),
        ),
      ),
    );
  }
}