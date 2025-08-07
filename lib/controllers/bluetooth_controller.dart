import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;
import '../models/device_model.dart';
import '../services/bluetooth_service.dart';
import '../services/wifi_service.dart';

class BluetoothController extends GetxController {
  final BluetoothService _bluetoothService = BluetoothService();
  final WifiService _wifiService = WifiService();

  final devices = <DeviceModel>[].obs;
  final isScanning = false.obs;
  final selectedDevice = Rxn<DeviceModel>();
  final connectedDevice = Rxn<DeviceModel>();
  final isConnected = false.obs;
  final discoveredServices = <fbp.BluetoothService>[].obs;

  final ssidController = TextEditingController();
  final passwordController = TextEditingController();
  final ipController = TextEditingController();
  final isWifiMode = false.obs;

  StreamSubscription? _scanSubscription;

  @override
  void onInit() {
    super.onInit();
    _scanSubscription = _bluetoothService.scanResults.listen((scannedDevices) {
      // This prevents the selection from being cleared on every update
      final uniqueDevices = <DeviceModel>{...scannedDevices}.toList();
      devices.value = uniqueDevices;
    });
  }

  void scanDevices() async {
    isScanning.value = true;
    devices.clear(); // Clear old results before starting
    await _bluetoothService.startScan();
    // Stop scan after a delay to conserve battery
    await Future.delayed(const Duration(seconds: 10), stopScan);
  }

  void stopScan() async {
    await _bluetoothService.stopScan();
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

  Future<void> connectToSelectedDevice() async {
    final deviceToConnect = selectedDevice.value;
    // Guard clause to prevent running with null device
    if (deviceToConnect == null) {
      Get.snackbar('Error', 'No device selected.');
      return;
    }

    stopScan(); // Stop scanning before connecting
    final success = await _bluetoothService.connectToDevice(deviceToConnect);
    if (success) {
      connectedDevice.value = deviceToConnect;
      isConnected.value = true;
      discoveredServices.value =
          (await _bluetoothService.discoverServices(deviceToConnect))
              .cast<fbp.BluetoothService>();
    }
  }

  Future<void> disconnectFromDevice() async {
    final deviceToDisconnect = connectedDevice.value;
    // Guard clause
    if (deviceToDisconnect == null) return;

    await _bluetoothService.disconnectFromDevice(deviceToDisconnect);
    isConnected.value = false;
    connectedDevice.value = null;
    discoveredServices.clear();
  }

  void sendConfiguration() async {
    if (isWifiMode.value) {
      // Logic for WiFi mode remains the same
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
      // Guard clause for Bluetooth mode
      if (connectedDevice.value == null) {
        Get.snackbar('Error', 'Please connect to a device first');
        return;
      }
      if (ssidController.text.isEmpty ||
          passwordController.text.isEmpty ||
          ipController.text.isEmpty) {
        Get.snackbar('Error', 'Please fill all fields');
        return;
      }
      await _bluetoothService.sendConfiguration(
        connectedDevice
            .value!, // Safe to use '!' here because of the check above
        ssidController.text,
        passwordController.text,
        ipController.text,
      );
    }
  }

  @override
  void onClose() {
    _scanSubscription?.cancel();
    stopScan();
    if (connectedDevice.value != null) {
      disconnectFromDevice();
    }
    ssidController.dispose();
    passwordController.dispose();
    ipController.dispose();
    super.onClose();
  }
}
