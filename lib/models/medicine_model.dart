import 'package:cloud_firestore/cloud_firestore.dart';

class Medicamento {
  String id;
  String nombre;
  DateTime fechaInicio;
  DateTime hora;
  int frecuenciaHoras;
  DateTime fechaFin;

  Medicamento({
    required this.id,
    required this.nombre,
    required this.fechaInicio,
    required this.hora,
    required this.fechaFin,
    required this.frecuenciaHoras,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'fechaInicio': fechaInicio,
      'hora': hora.toIso8601String(),
      'fechaFin': fechaFin,
      'frecuenciaHoras': frecuenciaHoras,
    };
  }

  factory Medicamento.fromMap(Map<String, dynamic> map) {
    return Medicamento(
      id: map['id'],
      nombre: map['nombre'],
      fechaInicio: (map['fechaInicio'] as Timestamp).toDate(), // Se convierte de String a DateTime usando DateTime.parse
      hora: DateTime.parse(map['hora']),
      fechaFin: (map['fechaFin'] as Timestamp).toDate(),
      frecuenciaHoras: map['frecuenciaHoras'],
    );
  }
}
