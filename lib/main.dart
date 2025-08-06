import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Request permissions
  await Permission.bluetoothScan.request();
  await Permission.bluetoothConnect.request();
  await Permission.locationWhenInUse.request();
  await Permission.notification.request();
  await Permission.camera.request(); // Add for QR scanner

  runApp(const BlueFiApp());
}

class BlueFiApp extends StatelessWidget {
  const BlueFiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BlueFi',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.login,
      getPages: AppRoutes.routes,
    );
  }
}