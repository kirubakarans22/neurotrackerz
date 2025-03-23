class SensorData {
  final int heartRate;
  final String latitude;
  final String longitude;
  final String status;
  final DateTime timestamp;

  SensorData({
    required this.heartRate,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.timestamp,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      heartRate: json['heartRate'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      status: json['status'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}