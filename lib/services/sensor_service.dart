import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

class SensorData {
  final double accelX;
  final double accelY;
  final double accelZ;
  final double gyroX;
  final double gyroY;
  final double gyroZ;

  const SensorData({
    this.accelX = 0,
    this.accelY = 0,
    this.accelZ = 0,
    this.gyroX = 0,
    this.gyroY = 0,
    this.gyroZ = 0,
  });
}

class SensorService {
  StreamSubscription<AccelerometerEvent>? _accelSub;
  StreamSubscription<GyroscopeEvent>? _gyroSub;

  double _ax = 0, _ay = 0, _az = 0;
  double _gx = 0, _gy = 0, _gz = 0;

  void iniciarLectura(Function(SensorData) onData) {
    _accelSub = accelerometerEventStream().listen((e) {
      _ax = e.x;
      _ay = e.y;
      _az = e.z;
      onData(_obtenerActual());
    });

    _gyroSub = gyroscopeEventStream().listen((e) {
      _gx = e.x;
      _gy = e.y;
      _gz = e.z;
      onData(_obtenerActual());
    });
  }

  SensorData _obtenerActual() {
    return SensorData(
      accelX: _ax,
      accelY: _ay,
      accelZ: _az,
      gyroX: _gx,
      gyroY: _gy,
      gyroZ: _gz,
    );
  }

  void detener() {
    _accelSub?.cancel();
    _gyroSub?.cancel();
  }
}