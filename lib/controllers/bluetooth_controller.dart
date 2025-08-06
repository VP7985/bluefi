import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/device_model.dart';
import '../services/bluetooth_service.dart';
import '../services/wifi_service.dart';

class BluetoothController extends GetxController {
  final BluetoothService _bluetoothService = BluetoothService();
  final WifiService _wifiService = WifiService();
  final devices = <DeviceModel>[].obs;
  final isScanning = false.obs;
  final selectedDevice = Rxn<DeviceModel>();
  final ssidController = TextEditingController();
  final passwordController = TextEditingController();
  final ipController = TextEditingController();
  final isWifiMode = false.obs; // Toggle between Bluetooth and WiFi

  void scanDevices() async {
    isScanning.value = true;
    devices.value = await _bluetoothService.scanDevices();
    isScanning.value = false;
  }

  void selectDevice(DeviceModel device) {
    selectedDevice.value = device;
  }

  void toggleMode() {
    isWifiMode.value = !isWifiMode.value;
  }

  void handleQrCode(String qrData) {
    final wifiData = _wifiService.parseWifiQrCode(qrData);
    if (wifiData.isNotEmpty) {
      ssidController.text = wifiData['ssid'] ?? '';
      passwordController.text = wifiData['password'] ?? '';
    }
  }

  void sendConfiguration() async {
    if (isWifiMode.value) {
      if (ssidController.text.isEmpty ||
          passwordController.text.isEmpty ||
          ipController.text.isEmpty) {
        Get.snackbar('Error', 'Please fill all fields');
        return;
      }
      await _wifiService.sendWifiConfiguration(
        ssidController.text,
        passwordController.text,
        ipController.text,
      );
    } else {
      if (selectedDevice.value == null) {
        Get.snackbar('Error', 'Please select a device');
        return;
      }
      if (ssidController.text.isEmpty ||
          passwordController.text.isEmpty ||
          ipController.text.isEmpty) {
        Get.snackbar('Error', 'Please fill all fields');
        return;
      }
      await _bluetoothService.sendConfiguration(
        selectedDevice.value!,
        ssidController.text,
        passwordController.text,
        ipController.text,
      );
    }
  }

  @override
  void onClose() {
    ssidController.dispose();
    passwordController.dispose();
    ipController.dispose();
    super.onClose();
  }
}