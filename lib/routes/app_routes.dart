import 'package:get/get.dart';
import '../screens/bluetooth_config_screen.dart';
import '../screens/login_screen.dart';
import '../screens/qr_scanner_screen.dart';
import '../screens/wifi_scanner_screen.dart';

class AppRoutes {
  static const login = '/login';
  static const bluetooth = '/bluetooth';
  static const wifi = '/wifi';

  static final routes = [
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: bluetooth, page: () => const BluetoothConfigScreen()),
    GetPage(name: wifi, page: () => const WiFiScannerScreen()),
    GetPage(name: '/qr', page: () => const QrScannerScreen()),
  ];
}