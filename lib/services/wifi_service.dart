import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:bluefi/main.dart';

class WifiService {
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

  // Parse QR code data (e.g., WIFI:S:ssid;P:password;T:WPA;;)
  Map<String, String> parseWifiQrCode(String qrData) {
    try {
      if (qrData.startsWith('WIFI:')) {
        final parts = qrData.split(';');
        String ssid = '';
        String password = '';
        for (var part in parts) {
          if (part.startsWith('S:')) {
            ssid = part.substring(2);
          } else if (part.startsWith('P:')) {
            password = part.substring(2);
          }
        }
        return {'ssid': ssid, 'password': password};
      }
      return {};
    } catch (e) {
      Get.snackbar('Error', 'Invalid WiFi QR code: $e');
      _showNotification('Error', 'Invalid WiFi QR code');
      return {};
    }
  }

  // Simulate sending WiFi configuration
  Future<bool> sendWifiConfiguration(String ssid, String password, String ipAddress) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      Get.snackbar('Success', 'WiFi configuration sent: $ssid');
      await _showNotification('Success', 'WiFi configuration sent: $ssid');
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to send WiFi configuration: $e');
      await _showNotification('Error', 'Failed to send WiFi configuration');
      return false;
    }
  }
}