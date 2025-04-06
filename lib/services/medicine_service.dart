import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicine_reminder/models/medicine_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
}

