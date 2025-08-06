class DeviceModel {
  final String id;
  final String name;
  final String? ipAddress;
  final String macAddress;

  DeviceModel({
    required this.id,
    required this.name,
    this.ipAddress,
    required this.macAddress,
  });
}