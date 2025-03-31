import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:medicine_reminder/screens/login_screen.dart';
import 'package:medicine_reminder/screens/register_screen.dart';
import 'package:medicine_reminder/screens/home_screen.dart';
import 'package:medicine_reminder/services/auth_service.dart';

void main() async {
  // Configuración Firebase
  WidgetsFlutterBinding.ensureInitialized();
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
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
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
