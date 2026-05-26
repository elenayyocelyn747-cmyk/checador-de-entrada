import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  final supabase = Supabase.instance.client;
  String? lastScannedId;
  DateTime? lastScanTime;
  bool isProcessing = false; // 👈 evita duplicados

  /// Calcular status según reglas
  String _calculateStatus(DateTime now) {
    final localNow = now.toLocal();
    final apertura = DateTime(localNow.year, localNow.month, localNow.day, 7, 0);
    final tolerancia = DateTime(localNow.year, localNow.month, localNow.day, 7, 35);

    if (localNow.isBefore(apertura)) {
      return "presente";
    } else if (localNow.isBefore(tolerancia)) {
      return "presente";
    } else {
      return "retardo";
    }
  }

  /// Guardar asistencia validando alumno y evitando duplicados
  Future<void> _saveAttendance(String studentId) async {
    final now = DateTime.now().toLocal();
    final today = DateTime(now.year, now.month, now.day);

    try {
      // Validar que el alumno exista
      final student = await supabase
          .from('students')
          .select('id')
          .eq('id', studentId)
          .maybeSingle();

      if (student == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Text('QR no corresponde a ningún alumno'),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        return;
      }

      // Verificar si ya existe asistencia hoy
      final existing = await supabase
          .from('attendance')
          .select()
          .eq('student_id', studentId)
          .gte('timestamp', today.toIso8601String());

      if (existing.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.warning, color: Colors.white),
                SizedBox(width: 8),
                Text('Ya se registró asistencia hoy'),
              ],
            ),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        return;
      }

      final status = _calculateStatus(now);

      await supabase.from('attendance').insert({
        'student_id': studentId,
        'status': status,
        'timestamp': now.toIso8601String(),
      });

      setState(() {
        lastScannedId = studentId;
        lastScanTime = now;
      });

      // ✅ Confirmación visual con SnackBar verde
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text('Asistencia guardada: $status'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 8),
              Text('Error al guardar asistencia: $e'),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear QR automático')),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              onDetect: (capture) async {
                if (isProcessing) return; // 👈 evita múltiples lecturas
                isProcessing = true;

                final barcode = capture.barcodes.first;
                final studentId = barcode.rawValue;

                if (studentId != null) {
                  await _saveAttendance(studentId);
                }

                // Espera 3 segundos antes de permitir otro escaneo
                await Future.delayed(const Duration(seconds: 3));
                isProcessing = false;
              },
            ),
          ),
          if (lastScannedId != null) ...[
            const SizedBox(height: 10),
            Text('Último alumno escaneado: $lastScannedId'),
          ],
        ],
      ),
    );
  }
}
