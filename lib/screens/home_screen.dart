import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    final User? usuario = FirebaseAuth.instance.currentUser;
    String? email = usuario?.email ?? '';

    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: TextButton.icon(
          onPressed: () {
            _salir(context);
          },
          label: const Text('Salir', style: TextStyle(fontSize: 25, color: Colors.white)),
          icon: const Icon(Icons.logout, color: Colors.white70),
        ),
        backgroundColor: Colors.lightBlue[900],
      ),
      body: Center(
        child: Text(
          'Bienvenido \n$email',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 25),
        ),
      ),
    );
  }

  void _salir(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }
}
