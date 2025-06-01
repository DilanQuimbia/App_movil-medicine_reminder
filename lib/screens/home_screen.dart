import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:medicine_reminder/services/medicine_service.dart';
import 'package:medicine_reminder/utils/helpers/snackbar_helper.dart';
import '../models/medicine_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Se obtiene el usuario actual
    // final User? usuario = FirebaseAuth.instance.currentUser;
    // String? email = usuario?.email ?? '';
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: TextButton.icon(
          onPressed: () {
            _salir(context);
          },
          label: const Text('Cerrar Sesión', style: TextStyle(fontSize: 25, color: Colors.white)),
          icon: const Icon(Icons.logout, color: Colors.white70),
        ),
        backgroundColor: Colors.green[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Center(
              child: Text(
                'Recordatorio de medicamento',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
            ),
            const SizedBox(height: 20),

            // Mostrar los medicamentos guardados
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: MedicamentoService().obtenerMedicamentosEnTiempoReal(), // Usamos el Stream de Firebase
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Column(
                      children: <Widget>[
                        Image.asset(
                          'assets/images/emergency.png',
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'No hay medicamentos agregados',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    );
                  }

                  // Obtener los medicamentos desde los datos del snapshot
                  List<Medicamento> medicamentos = snapshot.data!.docs.map((doc) {
                    return Medicamento.fromMap(doc.data() as Map<String, dynamic>);
                  }).toList();

                  return ListView.builder(
                    itemCount: medicamentos.length,
                    itemBuilder: (context, index) {
                      final medicamento = medicamentos[index];
                      return GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, '/detail_medicine', arguments: medicamento);
                        },
                          child: ListTile(
                            title: Text(medicamento.nombre),
                            subtitle: Text(DateFormat('dd/MM/yyyy').format(medicamento.fechaInicio)),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await _mostrarDialogoConfirmacion(context, medicamento.id);
                              },
                            ),
                          )
                      );
                      // return ListTile(
                      //   title: Text(medicamento.nombre),
                      //   subtitle: Text('Fecha Inicio: ${DateFormat('dd/MM/yyyy').format(medicamento.fechaInicio)}'),
                      //   //trailing: Icon(Icons.access_time),
                      // );
                    },
                  );
                },
              ),
            ),

            // Botón para agregar un medicamento
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add_medicine');
              },
              child: const Text('Agregar Medicamento'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _mostrarDialogoConfirmacion(BuildContext context, String medicamentoId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Impide que el usuario cierre el dialogo tocando fuera de él
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Eliminar medicamento?'),
          content: const Text('Confirmar: '),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  // Cierra el diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                // Eliminar medicamento
                await MedicamentoService().eliminarMedicamento(medicamentoId);
                Navigator.of(context).pop();  // Cierra el diálogo
                mostrarSnackBar("Medicamento eliminado", context);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  // Función para cerrar sesión
  void _salir(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }
}
