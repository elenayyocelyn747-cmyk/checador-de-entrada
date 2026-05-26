import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateStudentScreen extends StatefulWidget {
  const CreateStudentScreen({super.key});

  @override
  State<CreateStudentScreen> createState() => _CreateStudentScreenState();
}

class _CreateStudentScreenState extends State<CreateStudentScreen> {
  final supabase = Supabase.instance.client;
  final nameController = TextEditingController();
  final groupController = TextEditingController();

  Future<void> _crearAlumno() async {
    try {
      await supabase.from('students').insert({
        'name': nameController.text,
        'group_name': groupController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alumno creado correctamente ✅')),
      );

      // Limpia los campos después de crear
      nameController.clear();
      groupController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear alumno: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Estudiante')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: 'Nombre del alumno',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: groupController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.group),
                labelText: 'Grupo (ej. 1A, 2B)',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,   // 👈 fondo azul
                foregroundColor: Colors.white,  // 👈 texto blanco
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 12),
              ),
              onPressed: _crearAlumno,
              child: const Text(
                'Crear',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // 👈 asegura contraste
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
