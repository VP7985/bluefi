import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// Extend Equatable to handle object comparison
class DeviceModel extends Equatable {
  final String id;
  final String name;
  final String? ipAddress;
  final String macAddress;
  final BluetoothDevice? device;

  const DeviceModel({
    required this.id,
    required this.name,
    this.ipAddress,
    required this.macAddress,
    this.device,
  });

  // 'props' tells Equatable which properties to use for comparison.
  // Two DeviceModel objects are now considered equal if their 'id' is the same.
  @override
  List<Object?> get props => [id];
}
