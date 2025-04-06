import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:medicine_reminder/screens/login_screen.dart';
import 'package:medicine_reminder/screens/register_screen.dart';
import 'package:medicine_reminder/screens/home_screen.dart';
import 'package:medicine_reminder/services/auth_service.dart';
import 'package:medicine_reminder/screens/add_medicine_screen.dart';
import 'package:medicine_reminder/services/notifications_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicialización de BDD de zonas horarias
  tz.initializeTimeZones();

  // Solicitar permiso para enviar notificaciones
  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt >= 31) {
      final isPermissionGranted = await Permission.notification.isGranted;
      if (!isPermissionGranted) {
        await Permission.notification.request();
      }
    }
  }
  // Inicializa las notificaciones
  await NotificacionesService.inicializar();

  // Inicializa Firebase
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medicine Reminder',
      //  initialRoute: '/login'
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/add_medicine': (context) => AddMedicineScreen(),
      },
      // Verifica si existe un usuario autenticado
      home: StreamBuilder<User?>(
        // Stream: Escucha el estado de autenticación
        stream: AuthService().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // Si el usuario está autenticado, redirige a la pantalla Home
            return HomeScreen();
          } else {
            // Si no está autenticado, redirige a la pantalla de Login
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
