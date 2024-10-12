import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:todo_sensor/utils/show_notification.dart';

final sensorProvider = StateNotifierProvider<SensorNotifier, SensorData>((ref) {
  return SensorNotifier();
});

class SensorData {
  final List<double> accelerometerValues;
  final List<double> gyroscopeValues;

  SensorData(this.accelerometerValues, this.gyroscopeValues);
}

class SensorNotifier extends StateNotifier<SensorData> {
  SensorNotifier() : super(SensorData([0.0, 0.0, 0.0], [0.0, 0.0, 0.0])) {
    accelerometerEventStream().listen((AccelerometerEvent event) {
      _updateAccelerometer(event);
    });

    gyroscopeEventStream().listen((GyroscopeEvent event) {
      _updateGyroscope(event);
    });
  }

  void _updateAccelerometer(AccelerometerEvent event) {
    state = SensorData(
      [
        event.x.isFinite ? event.x : 0.0,
        event.y.isFinite ? event.y : 0.0,
        event.z.isFinite ? event.z : 0.0
      ],
      state.gyroscopeValues,
    );
    _checkForAlert();
  }

  void _updateGyroscope(GyroscopeEvent event) {
    state = SensorData(
      state.accelerometerValues,
      [
        event.x.isFinite ? event.x : 0.0,
        event.y.isFinite ? event.y : 0.0,
        event.z.isFinite ? event.z : 0.0
      ],
    );
    _checkForAlert();
  }

  void _checkForAlert() {
    if ((state.accelerometerValues[0].abs() > 10 &&
            state.accelerometerValues[1].abs() > 10) ||
        (state.gyroscopeValues[0].abs() > 5 &&
            state.gyroscopeValues[1].abs() > 5)) {
      showNotification(
        id: 1,
        title: "Sensor Alert",
        body: "High movement.",
        delay: 1,
      );
    }
  }
}
