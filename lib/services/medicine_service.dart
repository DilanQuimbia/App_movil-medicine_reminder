import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicine_reminder/models/medicine_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'notifications_service.dart';

class MedicamentoService {
  final User? user = FirebaseAuth.instance.currentUser;

  // Referencia a la colección de medicamentos del usuario autenticado
  CollectionReference get _medicamentosCollection =>
      FirebaseFirestore.instance.collection('users').doc(user?.uid).collection('medicamentos');

  // Para agregar más medicamentos
  Future<void> agregarMedicamento(Medicamento medicamento) async {
    try {
      await _medicamentosCollection.doc(medicamento.id).set(medicamento.toMap());
    } catch (e) {
      print("Error al agregar medicamento: $e");
    }
  }

  // Se obtienen los medicamentos del usuario en tiempo real usando un Stream
  Stream<QuerySnapshot> obtenerMedicamentosEnTiempoReal() {
    return _medicamentosCollection.snapshots();
  }

// Método para eliminar un medicamento
  Future<void> eliminarMedicamento(String medicamentoId) async {
    try {
      await NotificacionesService.cancelarNotificaciones(medicamentoId);
      await _medicamentosCollection.doc(medicamentoId).delete();
      print("✅ Medicamento y notificaciones eliminadas.");
      // Se elimina el medicamento de la base de datos
      await _medicamentosCollection.doc(medicamentoId.toString()).delete();
    } catch (e) {
      print("Error al eliminar medicamento: $e");
    }
  }

  Future<bool> existeMedicamento(String medicamentoId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('medicamentos')
        .doc(medicamentoId)
        .get();

    return doc.exists;
  }

}

