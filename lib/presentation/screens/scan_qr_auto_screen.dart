import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScanQrAutoScreen extends StatefulWidget {
  const ScanQrAutoScreen({super.key});

  @override
  State<ScanQrAutoScreen> createState() => _ScanQrAutoScreenState();
}

class _ScanQrAutoScreenState extends State<ScanQrAutoScreen> {
  final supabase = Supabase.instance.client;
  String? lastScannedId;
  DateTime? lastScanTime;

  /// Función para calcular el status automático con reglas de la secundaria
  String _calculateStatus(DateTime now) {
    final localNow = now.toLocal(); // 👈 fuerza hora local

    final apertura = DateTime(localNow.year, localNow.month, localNow.day, 7, 0);   // 07:00 AM
    final tolerancia = DateTime(localNow.year, localNow.month, localNow.day, 7, 35); // 07:35 AM

    if (localNow.isBefore(apertura)) {
      return "presente"; // llegó antes de abrir
    } else if (localNow.isBefore(tolerancia)) {
      return "presente"; // entre 07:00 y 07:35
    } else {
      return "retardo";  // después de 07:35
    }
  }

  /// Guardar asistencia automáticamente (una vez por día)
  Future<void> _saveAttendance(String studentId) async {
    final now = DateTime.now().toLocal(); // 👈 hora local
    final today = DateTime(now.year, now.month, now.day);

    try {
      // Verificar si ya existe asistencia para este alumno hoy
      final existing = await supabase
          .from('attendance')
          .select()
          .eq('student_id', studentId)
          .gte('timestamp', today.toIso8601String());

      if (existing.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ya se registró asistencia hoy')),
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Asistencia guardada: $status')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar asistencia: $e')),
      );
    }
  }

  /// Marcar faltas automáticamente al final del día (12:30 PM)
  Future<void> markAbsences() async {
    final now = DateTime.now().toLocal();
    final today = DateTime(now.year, now.month, now.day);

    // Buscar alumnos que NO tienen registro hoy
    final students = await supabase.from('students').select('id, name, group_name');
    for (final student in students) {
      final existing = await supabase
          .from('attendance')
          .select()
          .eq('student_id', student['id'])
          .gte('timestamp', today.toIso8601String());

      if (existing.isEmpty) {
        await supabase.from('attendance').insert({
          'student_id': student['id'],
          'status': 'falta',
          'timestamp': now.toIso8601String(),
        });
      }
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
              onDetect: (capture) {
                final barcode = capture.barcodes.first;
                final studentId = barcode.rawValue;
                final now = DateTime.now().toLocal();

                if (studentId != null) {
                  if (studentId != lastScannedId ||
                      lastScanTime == null ||
                      now.difference(lastScanTime!).inSeconds > 5) {
                    _saveAttendance(studentId);
                  }
                }
              },
            ),
          ),
          if (lastScannedId != null) ...[
            const SizedBox(height: 10),
            Text('Último alumno escaneado: $lastScannedId'),
          ],
          ElevatedButton(
            onPressed: () async {
              await markAbsences();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Faltas marcadas automáticamente')),
              );
            },
            child: const Text('Marcar faltas (12:30 PM)'),
          ),
        ],
      ),
    );
  }
}
