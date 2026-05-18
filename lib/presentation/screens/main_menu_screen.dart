import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return Scaffold(
      appBar: AppBar(title: const Text('Menú Principal')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/scanQr');
              },
              child: const Text('Escanear QR'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/createStudent');
              },
              child: const Text('Crear Estudiante'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/downloadInfo');
              },
              child: const Text('Descargar Información'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/searchStudent');
              },
              child: const Text('Buscar Alumno'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                await supabase.auth.signOut();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
              child: const Text('Cerrar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
