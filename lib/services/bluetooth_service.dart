import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/device_model.dart';
import 'package:bluefi/main.dart';

class BluetoothService {
  // Stream to provide real-time updates of scanned devices
  Stream<List<DeviceModel>> get scanResults =>
      FlutterBluePlus.scanResults.map((results) {
        return results.map((r) {
          String deviceName = r.device.name.isEmpty
              ? r.advertisementData.localName.isNotEmpty
                  ? r.advertisementData.localName
                  : 'Unknown Device'
              : r.device.name;
          return DeviceModel(
            id: r.device.id.toString(),
            name: deviceName,
            macAddress: r.device.id.toString(),
            device: r.device,
          );
        }).toList();
      });

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'bluefi_channel',
      'BlueFi Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  Future<void> startScan() async {
    try {
      if (!await FlutterBluePlus.isOn) {
        Get.snackbar('Error', 'Bluetooth is turned off. Please enable it.');
        await _showNotification('Error', 'Bluetooth is turned off');
        return;
      }
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
    } catch (e) {
      Get.snackbar('Error', 'Failed to start scan: $e');
    }
  }

  Future<void> stopScan() async {
    try {
      await FlutterBluePlus.stopScan();
    } catch (e) {
      Get.snackbar('Error', 'Failed to stop scan: $e');
    }
  }

  Future<bool> connectToDevice(DeviceModel device) async {
    if (device.device == null) return false;
    try {
      await device.device!.connect();
      await _showNotification('Connected', 'Connected to ${device.name}');
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect: $e');
      await _showNotification('Error', 'Failed to connect to ${device.name}');
      return false;
    }
  }

  Future<void> disconnectFromDevice(DeviceModel device) async {
    if (device.device == null) return;
    try {
      await device.device!.disconnect();
      await _showNotification(
          'Disconnected', 'Disconnected from ${device.name}');
    } catch (e) {
      Get.snackbar('Error', 'Failed to disconnect: $e');
    }
  }

  Future<List<Object>> discoverServices(DeviceModel device) async {
    if (device.device == null) return [];
    try {
      final services = await device.device!.discoverServices();
      await _showNotification('Services Discovered',
          'Found ${services.length} services on ${device.name}');
      return services;
    } catch (e) {
      Get.snackbar('Error', 'Failed to discover services: $e');
      return [];
    }
  }

  Future<bool> sendConfiguration(DeviceModel device, String ssid,
      String password, String ipAddress) async {
    // This is a placeholder for the actual implementation of writing to a characteristic
    // You would typically discover services and characteristics first, then write to the correct one.
    // For example:
    // final services = await discoverServices(device);
    // final service = services.firstWhere((s) => s.uuid == Guid("YOUR_SERVICE_UUID"));
    // final characteristic = service.characteristics.firstWhere((c) => c.uuid == Guid("YOUR_CHARACTERISTIC_UUID"));
    // await characteristic.write(...)
    try {
      await Future.delayed(const Duration(seconds: 1));
      Get.snackbar('Success', 'Configuration sent to ${device.name}');
      await _showNotification(
          'Success', 'Configuration sent to ${device.name}');
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to send configuration: $e');
      await _showNotification('Error', 'Failed to send configuration: $e');
      return false;
    }
  }
}
