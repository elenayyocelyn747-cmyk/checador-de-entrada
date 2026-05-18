import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReemitQrScreen extends StatefulWidget {
  const ReemitQrScreen({super.key});

  @override
  State<ReemitQrScreen> createState() => _ReemitQrScreenState();
}

class _ReemitQrScreenState extends State<ReemitQrScreen> {
  final supabase = Supabase.instance.client;
  final TextEditingController _controller = TextEditingController();
  String? alumnoId;
  String? alumnoNombre;
  bool loading = false;

  Future<void> _buscarAlumno() async {
    setState(() => loading = true);
    try {
      final response = await supabase
          .from('students')
          .select('id, name')
          .ilike('name', '%${_controller.text}%')
          .limit(1);

      if (response.isNotEmpty) {
        setState(() {
          alumnoId = response[0]['id'];
          alumnoNombre = response[0]['name'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Alumno no encontrado')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reemitir QR')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Nombre del alumno',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _buscarAlumno,
              child: const Text('Buscar'),
            ),
            const SizedBox(height: 20),
            if (loading) const CircularProgressIndicator(),
            if (alumnoId != null)
              Column(
                children: [
                  Text('Alumno: $alumnoNombre'),
                  const SizedBox(height: 12),
                  QrImageView(
                    data: alumnoId!,
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
