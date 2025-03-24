import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sensor_data.dart';

class ApiService {
  static const String baseUrl = "http://192.168.144.9:3000/api"; // Use your backend IP

  static Future<List<SensorData>> fetchSensorData() async {
    final response = await http.get(Uri.parse("$baseUrl/sensor-data"));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((data) => SensorData.fromJson(data)).toList();
    } else {
      throw Exception("Failed to load sensor data");
    }
  }
}