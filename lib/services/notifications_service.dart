import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificacionesService { // Recordatorio de medicamento
  static final FlutterLocalNotificationsPlugin _notificacionesPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> inicializar() async {
    const AndroidInitializationSettings androidInit =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(
        android: androidInit
    );

    await _notificacionesPlugin.initialize(initSettings);
    tz.initializeTimeZones();
  }

  static Future programarNotificacion(
      int id,
      String titulo,
      String cuerpo,
      DateTime horaInicio,
      DateTime fechaInicio, // Fecha inicial
      DateTime fechaFin, // Fecha final
      int frecuenciaHoras, // Frecuencia en horas
      ) async {

    // Fecha y hora selecionada por el usuario
    DateTime proximaNotificacion = DateTime(
      fechaInicio.year,
      fechaInicio.month,
      fechaInicio.day,
      horaInicio.hour,
      horaInicio.minute,
    );

    fechaFin = DateTime(
      fechaFin.year,
      fechaFin.month,
      fechaFin.day,
      23,
      59,
      59
    );

    proximaNotificacion = proximaNotificacion.add(Duration(minutes: frecuenciaHoras));
    while (proximaNotificacion.isBefore(fechaFin)) {
      await _notificacionesPlugin.zonedSchedule(
        id,
        titulo,
        cuerpo,
        tz.TZDateTime.from(proximaNotificacion, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'your channel id',
            'your channel name',
            importance: Importance.high,
            priority: Priority.high,
            enableLights: true,
            playSound: true,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      // Actualizamos la próxima notificación añadiendo la frecuencia en horas
      proximaNotificacion = proximaNotificacion.add(Duration(minutes: frecuenciaHoras));
      id++;  // Incrementamos el id para cada nueva notificación
    }
  }
}
