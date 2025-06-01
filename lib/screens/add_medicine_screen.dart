import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:medicine_reminder/services/medicine_service.dart';
import 'package:medicine_reminder/models/medicine_model.dart';
import 'package:medicine_reminder/services/notifications_service.dart';
import 'package:medicine_reminder/utils/helpers/snackbar_helper.dart';

class AddMedicineScreen extends StatefulWidget {
  @override
  _AddMedicamentoScreenState createState() => _AddMedicamentoScreenState();
}

class _AddMedicamentoScreenState extends State<AddMedicineScreen> {
  final _nombreController = TextEditingController();
  DateTime _fechaInicio = DateTime.now();
  DateTime _hora = DateTime.now();
  int _frecuencia = 4;
  DateTime _fechaFin = DateTime.now();
  final _medicamentoService = MedicamentoService();

  // Lógica para seleccionar la fecha inicial
  Future<void> _seleccionarFechaInicio() async {
    DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: _fechaInicio,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (fechaSeleccionada != null) {
      setState(() {
        _fechaInicio = DateTime(fechaSeleccionada.year, fechaSeleccionada.month, fechaSeleccionada.day);
      });
      print("Fecha Inicio: ${_fechaFin}");
    }
  }

  // Lógica para seleccionar la hora
  Future<void> _seleccionarHora() async {
    TimeOfDay? horaSeleccionada = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_hora),
    );
    if (horaSeleccionada != null) {
      setState(() {
        _hora = DateTime(_fechaInicio.year, _fechaInicio.month,
            _fechaInicio.day, horaSeleccionada.hour, horaSeleccionada.minute);
      });
    }
  }

  // Lógica para seleccionar la fecha de fin
  Future<void> _seleccionarFechaFin() async {
    DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: _fechaFin,
      firstDate: _fechaInicio, // La fecha de fin no puede ser antes de la fecha de inicio
      lastDate: DateTime(2100),
    );

    if (fechaSeleccionada != null) {
      if (fechaSeleccionada.isBefore(DateTime(_fechaInicio.year, _fechaInicio.month, _fechaInicio.day))) {
        // Si la fecha de fin es antes de la fecha de inicio, mostramos un error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La fecha final no es válida')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La fecha correcta')),
        );
        setState(() {
          _fechaFin = DateTime(fechaSeleccionada.year, fechaSeleccionada.month, fechaSeleccionada.day, 23, 59,59);
        });
      }
    }
  }

  void _guardarMedicamento() async {
    // Verificamos si el nombre está vacío
    if (_nombreController.text.isEmpty) {
      mostrarSnackBar('El nombre del medicamento es obligatorio', context);
      return;
    }

    Medicamento medicamento = Medicamento(
      id: const Uuid().v4(),
      nombre: _nombreController.text,
      fechaInicio: _fechaInicio,
      hora: _hora,
      frecuenciaHoras: _frecuencia,
      fechaFin: _fechaFin,
    );

    try {
      // Se guarda el medicamento en Firestore
      await _medicamentoService.agregarMedicamento(medicamento);

      if (mounted) {
        Navigator.pop(context); // Regresa a la pantalla HomeScreen
      }

      await NotificacionesService.programarNotificacion(
        medicamento.id, // El ID de la notificación
        'RECORDATORIO !!', // Título
        'Hora de ${medicamento.nombre}',
        medicamento.hora,
        medicamento.fechaInicio,
        medicamento.fechaFin,
        medicamento.frecuenciaHoras, // La frecuencia en minutos que seleccionó el usuario
      );
      // Mostramos el mensaje de éxito
      mostrarSnackBar('Medicamento guardado correctamente!', context);

    } catch (e) {
      print("Error al guardar medicamento: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Medicamento', style: TextStyle(fontSize: 25, color: Colors.white)),
        backgroundColor: Colors.green[900], // Color de fondo
        elevation: 0, // Elimina la sombra
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*// Título del formulario
            Text(
              'Nuevo medicamento',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.green[700],
                fontWeight: FontWeight.bold,
              ),
            ),*/
            const SizedBox(height: 20),

            // Campo de texto para el nombre del medicamento
            _buildTextField(
              controller: _nombreController,
              labelText: 'Nombre del medicamento',
            ),

            const SizedBox(height: 20),

            // Fecha de inicio
            _buildDateSelector(
              label: 'Fecha inicial:',
              fecha: _fechaInicio,
              onSelect: _seleccionarFechaInicio,
            ),

            const SizedBox(height: 20),

            // Hora de inicio
            _buildTimeSelector(
              label: 'Hora:',
              hora: _hora,
              onSelect: _seleccionarHora,
            ),

            const SizedBox(height: 20),

            // Fecha final
            _buildDateSelector(
              label: 'Fecha final:',
              fecha: _fechaFin,
              onSelect: _seleccionarFechaFin,
            ),

            const SizedBox(height: 20),

            // Frecuencia de la medicación
            _buildDropdown(),

            const SizedBox(height: 30),

            // Botón para guardar el medicamento
            Center(
              child: ElevatedButton(
                onPressed: _guardarMedicamento,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700], // Color del botón
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 50.0),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Guardar Medicamento'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String labelText}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.green[700]),
          contentPadding: const EdgeInsets.all(16),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDateSelector({required String label, required DateTime fecha, required VoidCallback onSelect}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label ${DateFormat('dd/MM/yyyy').format(fecha)}',
            style: TextStyle(color: Colors.green[700]),
          ),
          TextButton(
            onPressed: onSelect,
            child: const Text('Seleccionar', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector({required String label, required DateTime hora, required VoidCallback onSelect}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label ${DateFormat('HH:mm').format(hora)}',
            style: TextStyle(color: Colors.green[700]),
          ),
          TextButton(
            onPressed: onSelect,
            child: const Text('Seleccionar', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButton<int>(
        value: _frecuencia,
        isExpanded: true,
        items: [4, 5, 6, 8, 12, 24].map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text('Cada $value horas'),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _frecuencia = value!;
          });
        },
        underline: Container(),
        padding: const EdgeInsets.all(16),
        iconEnabledColor: Colors.green[700],
      ),
    );
  }
}
