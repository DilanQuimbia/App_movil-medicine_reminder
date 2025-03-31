import 'package:flutter/material.dart';

// Personalización de Text Field para el login(email,contraseña); registro(email, nombre, contraseña)
Widget customTextField({
  // Gestiona el texto ingresado por el usuario
  required TextEditingController controller,
  // Etiqueta del campo
  required String labelText,
  // Texto dentro del campo
  required String hintText,
  // Icon del campo
  required Icon prefixIcon,
  // Para la gestión icon a la derecha del campo ( para hacer visible la contraseña)
  IconButton? suffixIcon,
  // Campo oculto
  bool obscureText = false,
  // Tipo de teclado
  TextInputType keyboardType = TextInputType.text,

}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.black12,
        labelStyle: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
        hintStyle: const TextStyle(
          color: Colors.white54,
        ),
        // Borde cuando el campo no está selecionado
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(color: Colors.white, width: 0.5),
        ),
        // Borde cuando el campo está selecionado por el usuario
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
        labelText: labelText,
        hintText: hintText,
      ),
    ),
  );
}
