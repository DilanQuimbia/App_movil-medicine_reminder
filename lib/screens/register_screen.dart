import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medicine_reminder/widgets/custom_text_field.dart';
import 'package:medicine_reminder/utils/helpers/snackbar_helper.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _contrasenaVisible1 = false;
  bool _contrasenaVisible2 = false;
  static bool visible = false;

  //FirebaseAuth auth = FirebaseAuth.instance;
  AuthService authService = AuthService();

  // Gestión de texto ingresado por el usuario
  TextEditingController _emailController = TextEditingController();
  TextEditingController _usuarioController = TextEditingController();
  TextEditingController _contrasenaController1 = TextEditingController();
  TextEditingController _contrasenaController2 = TextEditingController();

  // FormKey para la validación
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    visible = false;
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 150.0, bottom: 20),
                child: const Text(
                  'Registrarse',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: customTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.mail_outline_rounded, color: Colors.white70),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              SizedBox(height: 20), // Espacio entre campos
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: customTextField(
                  controller: _usuarioController,
                  labelText: 'Nombre',
                  hintText: 'Nombre',
                  prefixIcon: Icon(Icons.account_circle_outlined, color: Colors.white70),
                  keyboardType: TextInputType.name,
                ),
              ),
              SizedBox(height: 20), // Espacio entre campos
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: customTextField(
                  controller: _contrasenaController1,
                  labelText: 'Contraseña',
                  hintText: 'Contraseña',
                  obscureText: !_contrasenaVisible1,
                  prefixIcon: Icon(Icons.lock_outline_rounded, color: Colors.white70),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _contrasenaVisible1 ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        _contrasenaVisible1 = !_contrasenaVisible1;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20), // Espacio entre campos
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: customTextField(
                  controller: _contrasenaController2,
                  labelText: 'Repite contraseña',
                  hintText: 'Repite contraseña',
                  obscureText: !_contrasenaVisible2,
                  prefixIcon: Icon(Icons.lock_outline_rounded, color: Colors.white70),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _contrasenaVisible2 ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        _contrasenaVisible2 = !_contrasenaVisible2;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 40), // Espacio antes del botón de registro

              // Botón de Registro
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!_emailController.text.contains('@')) {
                        mostrarSnackBar('Introduzca un email correcto', context);
                      } else if (_usuarioController.text.isEmpty) {
                        mostrarSnackBar('Introduzca su nombre', context);
                      } else if (_contrasenaController1.text.length < 6) {
                        mostrarSnackBar('La contraseña debe tener al menos 6 caracteres', context);
                      } else if (_contrasenaController1.text != _contrasenaController2.text) {
                        mostrarSnackBar('Las contraseñas no coinciden', context);
                      } else {
                        setState(() {
                          cambiarVisibilidadIndicadorProgreso();
                        });
                        _registerUser(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black45,
                      shadowColor: Colors.black45,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(color: Colors.white70, width: 2),
                      ),
                    ),
                    child: const Text(
                      'Registrarse',
                      style: TextStyle(
                        fontSize: 19,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Espacio después del botón de registro

              // Indicador de progreso
              Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: visible,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Container(
                    width: 290,
                    margin: EdgeInsets.only(),
                    child: LinearProgressIndicator(
                      minHeight: 2,
                      backgroundColor: Colors.blueGrey[800],
                      valueColor: AlwaysStoppedAnimation(Colors.white),
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

  void cambiarVisibilidadIndicadorProgreso() {
    visible = !visible;
  }

  Future<void> _registerUser(BuildContext context) async {
    setState(() {
      cambiarVisibilidadIndicadorProgreso(); // Mostrar el indicador de progreso
    });

    try {
      User? usuario = await authService.registerUser(
        _emailController.text.trim(),
        _contrasenaController1.text.trim(),
      );
      if (usuario != null) {
        // Si el registro es exitoso, se muestra mensaje de éxito
        mostrarSnackBar("Usuario creado correctamente", context);
        // Navegar a la pantalla de inicio
        Navigator.pushNamed(context, '/home');
      }
    } catch (e) {
      mostrarSnackBar(e.toString(), context); // El error proviene de _handleAuthException en aut_service
    } finally {
      setState(() {
        cambiarVisibilidadIndicadorProgreso(); // Ocultar el indicador de progreso
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _contrasenaController1.dispose();
    _contrasenaController2.dispose();
    _usuarioController.dispose();
    super.dispose();
  }
}

