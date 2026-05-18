import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Crear nuevo alumno'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateStudentScreen()),
              );
            },
          ),
          // Aquí luego puedes añadir más opciones de configuración
        ],
      ),
    );
  }
}

class CreateStudentScreen extends StatefulWidget {
  const CreateStudentScreen({super.key});

  @override
  State<CreateStudentScreen> createState() => _CreateStudentScreenState();
}

class _CreateStudentScreenState extends State<CreateStudentScreen> {
  final supabase = Supabase.instance.client;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _groupController = TextEditingController();
  bool loading = false;

  Future<void> _crearAlumno() async {
    setState(() => loading = true);
    try {
      await supabase.from('students').insert({
        'name': _nameController.text,
        'group_name': _groupController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alumno creado correctamente')),
      );

      _nameController.clear();
      _groupController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear alumno: $e')),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear alumno')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre del alumno',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _groupController,
              decoration: const InputDecoration(
                labelText: 'Grupo (ej. 1A)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _crearAlumno,
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
