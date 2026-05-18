import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'scan_qr_screen.dart'; // asegúrate que este archivo exista en lib/presentation/screens

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checador Escolar'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bienvenida Elena 👋',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Probar conexión con Supabase
                try {
                  final response = await supabase
                      .from('attendance')
                      .select()
                      .limit(1);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Conexión OK: $response')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error de conexión: $e')),
                  );
                }
              },
              child: const Text('Probar conexión'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScanQrScreen(),
                  ),
                );
              },
              child: const Text('Escanear QR'),
            ),
          ],
        ),
      ),
    );
  }
}
