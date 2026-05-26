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
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            _menuButton(
              context,
              icon: Icons.qr_code_scanner,
              label: 'Escanear QR',
              route: '/scanQr',
              color: Colors.blue,
            ),
            _menuButton(
              context,
              icon: Icons.person_add,
              label: 'Crear Estudiante',
              route: '/createStudent',
              color: Colors.purple,
            ),
            _menuButton(
              context,
              icon: Icons.download,
              label: 'Descargar Info',
              route: '/downloadInfo',
              color: Colors.green,
            ),
            _menuButton(
              context,
              icon: Icons.search,
              label: 'Buscar Alumno',
              route: '/searchStudent',
              color: Colors.orange,
            ),
            _menuButton(
              context,
              icon: Icons.logout,
              label: 'Cerrar Sesión',
              route: '/login',
              color: Colors.red,
              onTap: () async {
                await supabase.auth.signOut();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
    required Color color,
    VoidCallback? onTap,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(20),
      ),
      onPressed: onTap ?? () => Navigator.pushNamed(context, route),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.white),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
