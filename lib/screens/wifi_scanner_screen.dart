import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/wifi_controller.dart';

class WiFiScannerScreen extends StatelessWidget {
  const WiFiScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final WiFiController controller = Get.put(WiFiController());

    return Scaffold(
      appBar: AppBar(title: const Text('WiFi Device Scanner')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FilledButton(
              onPressed: controller.scanNetwork,
              child: const Text('Scan Network'),
            ),
            const SizedBox(height: 16),
            Obx(() => controller.isScanning.value
                ? const CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: controller.devices.length,
                      itemBuilder: (context, index) {
                        final device = controller.devices[index];
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.devices),
                            title: Text(device.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Chip(label: Text('IP: ${device.ipAddress}')),
                                Chip(label: Text('MAC: ${device.macAddress}')),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}