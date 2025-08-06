import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../controllers/bluetooth_controller.dart';

class QrScannerScreen extends StatelessWidget {
  const QrScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BluetoothController>();
    MobileScannerController scannerController = MobileScannerController();

    return Scaffold(
      appBar: AppBar(title: const Text('Scan WiFi QR Code')),
      body: MobileScanner(
        controller: scannerController,
        onDetect: (barcodeCapture) {
          final String? code = barcodeCapture.barcodes.first.rawValue;
          if (code != null) {
            controller.handleQrCode(code);
            Get.back();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => scannerController.toggleTorch(),
        child: const Icon(Icons.flash_on),
      ),
    );
  }
}