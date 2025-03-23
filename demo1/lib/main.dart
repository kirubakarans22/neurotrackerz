import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'services/api_service.dart';
import 'models/sensor_data.dart';

void main() {
  runApp(SensorMonitorApp());
}

class SensorMonitorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Real-Time Sensor Monitor',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SensorDataScreen(),
    );
  }
}

class SensorDataScreen extends StatefulWidget {
  @override
  _SensorDataScreenState createState() => _SensorDataScreenState();
}

class _SensorDataScreenState extends State<SensorDataScreen> {
  List<SensorData> sensorDataList = [];
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _connectWebSocket();
  }

  void _fetchData() async {
    try {
      final data = await ApiService.fetchSensorData();
      setState(() => sensorDataList = data);
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  void _connectWebSocket() {
    socket = IO.io("http://192.168.144.9:3000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });

    socket.connect();
    socket.on("sensorData", (data) {
      final newData = SensorData.fromJson(data);
      setState(() => sensorDataList.insert(0, newData));
    });
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Fall Detected":
        return Colors.red;
      case "Emergency":
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case "Fall Detected":
        return Icons.warning;
      case "Emergency":
        return Icons.error;
      default:
        return Icons.check_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Real-Time Sensor Data")),
      body: RefreshIndicator(
        onRefresh: () async => _fetchData(),
        child: sensorDataList.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: sensorDataList.length,
                itemBuilder: (context, index) {
                  final sensor = sensorDataList[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    color: _getStatusColor(sensor.status).withOpacity(0.1),
                    child: ListTile(
                      leading: Icon(_getStatusIcon(sensor.status), color: _getStatusColor(sensor.status)),
                      title: Text(
                        "Heart Rate: ${sensor.heartRate} BPM",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Status: ${sensor.status}"),
                          Text("Location: ${sensor.latitude}, ${sensor.longitude}"),
                          Text("Time: ${sensor.timestamp}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}