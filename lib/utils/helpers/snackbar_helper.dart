import 'package:flutter/material.dart';
// Mensaje SnackBar personalizado
void mostrarSnackBar(String message, BuildContext context) async {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message, style: const TextStyle(color: Colors.white),),
    duration: const Duration(milliseconds: 1200),
    backgroundColor: Colors.blueGrey[800],
  ));
}