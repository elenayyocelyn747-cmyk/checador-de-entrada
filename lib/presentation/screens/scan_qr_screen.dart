import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScanQrScreen extends StatelessWidget {
  const ScanQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return Scaffold(
      appBar: AppBar(title: const Text('Escanear QR')),
      body: MobileScanner(
        onDetect: (barcodeCapture) {
          final String? code = barcodeCapture.barcodes.first.rawValue;
          if (code != null) {
            supabase.from('attendance').insert({
              'student_id': code,
              'status': 'Present',
              'timestamp': DateTime.now().toIso8601String(),
            }).then((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Asistencia registrada: $code')),
              );
            }).catchError((e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al registrar: $e')),
              );
            });
          }
        },
      ),
    );
  }
}
