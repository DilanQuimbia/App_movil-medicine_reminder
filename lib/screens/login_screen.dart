import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medicine_reminder/services/auth_service.dart';
import 'package:medicine_reminder/widgets/custom_text_field.dart';
import 'package:medicine_reminder/utils/helpers/snackbar_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;

  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkUserAuthStatus();
  }

  void _checkUserAuthStatus() {
    authService.authStateChanges.listen((User? user) {
      if (user == null) {
        print("Usuario no autenticado");
      } else {
        print("Usuario autenticado");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Orientación vertical
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Scaffold(
      backgroundColor: Colors.lightBlue[900],
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 120.0, bottom: 0.0),
                child: Text(
                  'Iniciar sesión',
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0, bottom: 50.0),
                child: Center(
                  child: Container(
                    width: 180,
                    height: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Image.asset('assets/auth.png'),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: customTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  hintText: 'Email',
                  prefixIcon: const Icon(
                    Icons.mail_outline_rounded,
                    color: Colors.white70,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 10.0, bottom: 30.0),
                child: customTextField(
                  controller: _passwordController,
                  labelText: 'Contraseña',
                  hintText: 'Contraseña',
                  prefixIcon: const Icon(
                    Icons.lock_outline_rounded,
                    color: Colors.white70,
                  ),
                  obscureText: !_passwordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                  keyboardType: TextInputType.visiblePassword,
                ),
              ),
              Container(
                height: 50,
                width: 350,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black45,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: const BorderSide(
                        color: Colors.white70,
                        width: 2,
                      ),
                    ),
                  ),
                  child: const Text(
                    'Acceder',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Container(
                height: 70,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text(
                    'Registrar',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    final formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save(); // Guarda el estado del formulario
      try {
        await authService.signIn(
          _emailController.text,
          _passwordController.text,
        );
        Navigator.pushNamed(context, '/home');
      } catch (e) {
        mostrarSnackBar(e.toString(), context); // El error proviene de _handleLoginException en aut_service
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
