import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'medicine_service.dart';

class NotificacionesService { // Recordatorio de medicamento
  static final FlutterLocalNotificationsPlugin _notificacionesPlugin =
  FlutterLocalNotificationsPlugin();

  // Mapa para almacenar las notificaciones programadas por medicamento
  static final Map<String, Set<int>> _notificacionesPorMedicamento = {};

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
      String medicamentoId,
      String nombre,
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
    //final medicamentoService = MedicamentoService();
/*

    DateTime fechaActual = DateTime.now();

    if(fechaActual.isBefore(proximaNotificacion)){

    }


    if(proximaNotificacion.isBefore(fechaFin)){
      // Actualizamos la próxima notificación añadiendo la frecuencia en horas
      proximaNotificacion = proximaNotificacion.add(Duration(minutes: frecuenciaHoras));
      increment++;  // Incrementamos el id para cada nueva notificación
    }
*/
    /*int totalDosis = ((fechaFin.difference(fechaInicio).inMinutes) / frecuenciaHoras).ceil();

    int increment = 0;*/
    int idNotificacion = medicamentoId.hashCode;
    //proximaNotificacion = proximaNotificacion.add(Duration(minutes: frecuenciaHoras));

    // Inicializamos el conjunto de IDs de notificaciones para el medicamento
    /*if (!notificacionesPorMedicamento.containsKey(medicamentoId)) {
      notificacionesPorMedicamento[idNotificacion] = Set<int>().cast<int>();
    }*/
    // Inicializamos el set si no existe
    _notificacionesPorMedicamento.putIfAbsent(medicamentoId, () => <int>{});
    //_notificacionesPorMedicamento[medicamentoId]?.add(idNotificacion);
    //print("id inicial: $idNotificacion");
    while (proximaNotificacion.isBefore(fechaFin)) {
      // Calculamos el progreso como el porcentaje de dosis tomadas
      /*double progreso = (increment / totalDosis) * 100;
      print("Progreso: $progreso, Incremento: $increment, Total Dosis: $totalDosis");*/

      //DateTime fechaActual = DateTime.now();

      //int maxProgress = 0;

      /*if(proximaNotificacion < fechaFin){
        Duration duracionDesdeInicio = fechaActual.difference(fechaInicio);
        int dosisTomadas = (duracionDesdeInicio.inHours / frecuenciaHoras).floor(); // Redondeamos para obtener las dosis pasadas
        // Calculamos las dosis restantes
        Duration duracionHastaFin = fechaFin.difference(fechaActual);
        int dosisRestantes = (duracionHastaFin.inHours / frecuenciaHoras).floor(); // Cuántas dosis faltan
        //maxProgress = dosisRestantes;
      }else{
        proximaNotificacion = proximaNotificacion.add(Duration(minutes: frecuenciaHoras));
      }*/
      //int id = medicamentoId.hashCode ^ proximaNotificacion.hashCode;  // Generamos un ID único para cada notificación

/*      final existe = await medicamentoService.existeMedicamento(medicamentoId);
      if (!existe) {
        //print("❌ Medicamento eliminado, se detiene la programación de notificaciones.");
        break;
      }*/

      await _notificacionesPlugin.zonedSchedule(
        idNotificacion,
        nombre,
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
            //showProgress: true, // Habilitamos el progreso
            //progress: progreso.toInt(), // Convertimos el progreso a un entero
            //maxProgress: 100, // Definimos el progreso máximo
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      //idsNotificacionesProgramadas.add(id);
      //id++;
      // Guardamos el id de la notificación programada
      /*if(proximaNotificacion.isBefore(fechaFin)){
        // Actualizamos la próxima notificación añadiendo la frecuencia en horas
        proximaNotificacion = proximaNotificacion.add(Duration(minutes: frecuenciaHoras));
        increment++;  // Incrementamos el id para cada nueva notificación
      }*/
      // Añadir el ID de la notificación a la lista de notificaciones del medicamento
      //notificacionesPorMedicamento[medicamentoId]!.add(id);
      _notificacionesPorMedicamento[medicamentoId]?.add(idNotificacion);
      proximaNotificacion = proximaNotificacion.add(Duration(hours: frecuenciaHoras));
      idNotificacion++;
    }
  }

  // Método para cancelar las notificaciones de un medicamento
  static Future<void> cancelarNotificaciones(String medicamentoId) async {
    final ids = _notificacionesPorMedicamento[medicamentoId];
    if (ids != null && ids.isNotEmpty) {
      for (var id in ids) {
        await _notificacionesPlugin.cancel(id);
      }
      _notificacionesPorMedicamento.remove(medicamentoId);
      print("✅ Notificaciones canceladas para $medicamentoId");
    }
  }
}
