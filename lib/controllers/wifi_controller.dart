import 'package:get/get.dart';
import '../models/device_model.dart';
import '../services/network_service.dart';

class WiFiController extends GetxController {
  final NetworkService _networkService = NetworkService();
  final devices = <DeviceModel>[].obs;
  final isScanning = false.obs;

  void scanNetwork() async {
    isScanning.value = true;
    devices.value = await _networkService.scanNetwork();
    isScanning.value = false;
  }
}