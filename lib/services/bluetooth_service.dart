import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/device_model.dart';
import 'package:bluefi/main.dart';

class BluetoothService {
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

  Future<List<DeviceModel>> scanDevices() async {
    try {
      // Check if Bluetooth is enabled
      if (!await FlutterBluePlus.isOn) {
        Get.snackbar('Error', 'Bluetooth is turned off. Please enable it.');
        await _showNotification('Error', 'Bluetooth is turned off');
        return [];
      }

      // Start scanning
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 6)); // Increased timeout
      List<DeviceModel> devices = [];

      // Listen for scan results with real-time updates
      await for (var scanResult in FlutterBluePlus.scanResults) {
        devices = scanResult.map((r) {
          String deviceName = r.device.name.isEmpty
              ? r.advertisementData.localName.isNotEmpty
                  ? r.advertisementData.localName
                  : 'Unknown Device'
              : r.device.name;
          return DeviceModel(
            id: r.device.id.toString(),
            name: deviceName,
            macAddress: r.device.id.toString(),
          );
        }).toList();
      }

      await FlutterBluePlus.stopScan();
      await _showNotification('Scan Complete', 'Found ${devices.length} Bluetooth devices');
      return devices;
    } catch (e) {
      Get.snackbar('Error', 'Failed to scan Bluetooth devices: $e');
      await _showNotification('Error', 'Failed to scan Bluetooth devices: $e');
      return [];
    }
  }

  Future<bool> sendConfiguration(DeviceModel device, String ssid, String password, String ipAddress) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      Get.snackbar('Success', 'Configuration sent to ${device.name}');
      await _showNotification('Success', 'Configuration sent to ${device.name}');
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to send configuration: $e');
      await _showNotification('Error', 'Failed to send configuration: $e');
      return false;
    }
  }
}