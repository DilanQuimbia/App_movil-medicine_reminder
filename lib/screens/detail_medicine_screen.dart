import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/medicine_model.dart';
import '../services/medicine_service.dart';

class DetailMedicineScreen extends StatelessWidget {
  const DetailMedicineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Recibimos el medicamento desde los argumentos
    final Medicamento medicamento = ModalRoute.of(context)!.settings.arguments as Medicamento;

    return Scaffold(
      appBar: AppBar(
        title: Text(medicamento.nombre),
        backgroundColor: Colors.green[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Nombre: ${medicamento.nombre}', style: const TextStyle(fontSize: 20)),
            Text('Fecha de inicio: ${DateFormat('dd/MM/yyyy').format(medicamento.fechaInicio)}'),
            Text('Hora: ${DateFormat('HH:mm').format(medicamento.hora)}'),
            Text('Frecuencia: Cada ${medicamento.frecuenciaHoras} horas'),
            Text('Fecha fin: ${DateFormat('dd/MM/yyyy').format(medicamento.fechaFin)}'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // Lógica de edición
                    Navigator.pushNamed(context, '/editMedicine', arguments: medicamento);
                  },
                  child: const Text('Editar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Lógica para eliminar el medicamento
                    await MedicamentoService().eliminarMedicamento(medicamento.id);
                    Navigator.pop(context); // Volver a la pantalla principal
                  },
                  child: const Text('Eliminar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
