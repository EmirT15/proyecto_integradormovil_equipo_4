import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(settings: const InitializationSettings(android: android));
    _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> alerteStockBajo(String producto, int cantidad) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'canal_inventario',
        'Alertas de Inventario',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
    await _plugin.show(
      id: DateTime.now().millisecond,
      title: '⚠️ Alerta de Stock Bajo',
      body: 'El producto "$producto" cuenta con solo $cantidad unidades.',
      notificationDetails: details,
    );
  }
}