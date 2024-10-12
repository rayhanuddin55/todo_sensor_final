import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_sensor/ui/sensor_app/sensor_notifier.dart';

class SensorTrackingPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    final sensorData = ref.watch(sensorProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor Tracking'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SensorGraph(
                title: "Accelerometer",
                values: sensorData.accelerometerValues,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SensorGraph(
                title: "Gyroscope",
                values: sensorData.gyroscopeValues,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SensorGraph extends StatelessWidget {
  final String title;
  final List<double> values;

  const SensorGraph({required this.title, required this.values});

  bool _isValidValue(double value) {
    return value.isFinite && !value.isNaN;
  }

  @override
  Widget build(BuildContext context) {
    // Filter out invalid values
    final validValues = values.map((v) => _isValidValue(v) ? v : 0.0).toList();

    return Column(
      children: [
        Text(title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Expanded(
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                bottomTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: true)),
              ),
              borderData: FlBorderData(show: true),
              minX: 0,
              maxX: 2,
              minY: -15,
              maxY: 15,
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    FlSpot(0.0, validValues[0]),
                    FlSpot(1.0, validValues[1]),
                    FlSpot(2.0, validValues[2]),
                  ],
                  isCurved: true,
                  barWidth: 4,
                  color: Colors.blue,
                  dotData: FlDotData(show: false),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
