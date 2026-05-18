import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CreateStudentScreen extends StatefulWidget {
  const CreateStudentScreen({super.key});

  @override
  State<CreateStudentScreen> createState() => _CreateStudentScreenState();
}

class _CreateStudentScreenState extends State<CreateStudentScreen> {
  final supabase = Supabase.instance.client;
  final nameController = TextEditingController();
  final groupController = TextEditingController();

  Map<String, dynamic>? createdStudent;

  Future<void> _saveStudent() async {
    try {
      final response = await supabase.from('students').insert({
        'name': nameController.text.trim(),
        'group_name': groupController.text.trim(), // 👈 usa el campo real
      }).select(); // 👈 devuelve el registro insertado

      if (response.isNotEmpty) {
        setState(() {
          createdStudent = response.first;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear alumno: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Alumno')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre del alumno'),
            ),
            TextField(
              controller: groupController,
              decoration: const InputDecoration(labelText: 'Grupo (ej. 1A)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveStudent,
              child: const Text('Guardar'),
            ),
            const SizedBox(height: 20),
            if (createdStudent != null) ...[
              Text('Alumno: ${createdStudent!['name']}'),
              Text('Grupo: ${createdStudent!['group_name']}'),
              const SizedBox(height: 10),
              QrImageView(
                data: createdStudent!['id'], // 👈 QR con el UUID único
                version: QrVersions.auto,
                size: 200.0,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
