import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bluetooth_controller.dart';
import '../models/device_model.dart';
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
          child: SingleChildScrollView( // Added to prevent overflow
            child: Column(
              children: [
                Obx(() => controller.isWifiMode.value
                    ? _buildWifiModeTopSection(controller)
                    : _buildBluetoothModeTopSection(controller)),
                const SizedBox(height: 16),
                _buildConfigFields(controller),
              ],
            ),
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

  Widget _buildWifiModeTopSection(BluetoothController controller) {
    return FilledButton(
      onPressed: () => Get.to(() => const QrScannerScreen()),
      child: const Text('Scan WiFi QR Code'),
    );
  }

  Widget _buildBluetoothModeTopSection(BluetoothController controller) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Obx(() => FilledButton(
                  onPressed: controller.isScanning.value ? null : controller.scanDevices,
                  child: Text(controller.isScanning.value ? 'Scanning...' : 'Scan Devices'),
                )),
            FilledButton(
              onPressed: controller.stopScan,
              child: const Text('Stop Scan'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Obx(() {
           if (controller.isScanning.value && controller.devices.isEmpty) {
             return const Center(child: CircularProgressIndicator());
           }
           // Use a fixed height to prevent layout jumps
           return SizedBox(
             height: 200,
             child: controller.devices.isEmpty
                 ? const Center(child: Text("No devices found. Press 'Scan'."))
                 : ListView.builder(
               itemCount: controller.devices.length,
               itemBuilder: (context, index) {
                 final device = controller.devices[index];
                 return Card(
                   child: Obx(() => ListTile(
                     title: Text(device.name.isEmpty ? 'Unknown Device' : device.name),
                     subtitle: Text(device.id),
                     trailing: Radio<DeviceModel>(
                       value: device,
                       groupValue: controller.selectedDevice.value,
                       // This is now safe because DeviceModel uses Equatable
                       onChanged: (value) {
                         if (value != null) {
                           controller.selectDevice(value);
                         }
                       },
                     ),
                   )),
                 );
               },
             ),
           );
        }),
      ],
    );
  }

  Widget _buildConfigFields(BluetoothController controller) {
    return Column(
      children: [
        Obx(() {
          final selected = controller.selectedDevice.value;
          final connected = controller.connectedDevice.value;
          final isConnected = controller.isConnected.value;

          if (controller.isWifiMode.value || selected == null) {
            return const SizedBox.shrink();
          }

          return Column(
            children: [
              const Divider(height: 20),
              Text(
                "Selected: ${selected.name.isEmpty ? 'Unknown Device' : selected.name}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (isConnected && connected == selected)
                Text("Status: Connected", style: TextStyle(color: Colors.green.shade700)),
              const SizedBox(height: 10),
              FilledButton(
                onPressed: (isConnected && connected == selected)
                    ? controller.disconnectFromDevice
                    : controller.connectToSelectedDevice,
                child: Text((isConnected && connected == selected) ? 'Disconnect' : 'Connect'),
              ),
              const Divider(height: 20),
            ],
          );
        }),
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
    );
  }
}