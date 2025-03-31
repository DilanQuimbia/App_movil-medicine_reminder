import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Autenticación con email y contraseña
  Future<UserCredential> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw _handleLoginException(e);
    } catch (e) {
      throw 'Ocurrió un error desconocido';
    }
  }

  // Listener de cambios de estado de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Registro de usuario
  Future<User?> registerUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Ocurrió un error desconocido';
    }
  }
  // Manejar excepción de usuario en el registro
  String _handleAuthException(FirebaseAuthException e) {
    if (e.code == "weak-password") {
      return "Contraseña demasiado débil";
    } else if (e.code == "email-already-in-use") {
      return "Ese usuario ya existe";
    } else {
      return "Ocurrió un error al crear el usuario";
    }
  }

  // Manejar excepción de usuario en el login
  String _handleLoginException(FirebaseAuthException e) {
    // Manejar errores específicos de Firebase
    if (e.code == "user-not-found") {
      return "Usuario desconocido";
    } else if (e.code == "wrong-password") {
      return "Contraseña incorrecta";
    } else if (e.code == "invalid-email") {
      return "El formato del email no es válido";
    } else {
      return "Lo sentimos, hubo un error";
    }
  }
}
