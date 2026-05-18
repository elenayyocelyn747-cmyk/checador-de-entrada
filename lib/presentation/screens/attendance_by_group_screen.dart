import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AttendanceByGroupScreen extends StatefulWidget {
  const AttendanceByGroupScreen({super.key});

  @override
  State<AttendanceByGroupScreen> createState() => _AttendanceByGroupScreenState();
}

class _AttendanceByGroupScreenState extends State<AttendanceByGroupScreen> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> attendanceList = [];
  String selectedGroup = ""; // 👈 ya no es nullable
  List<String> groups = [
    "Grupo 1A", "Grupo 2A", "Grupo 2B", "Grupo 3A", "Grupo 3C",
    "Grupo 4A", "Grupo 4B", "Grupo 5A", "Grupo 5B", "Grupo 6A",
    "Grupo 6B", "Grupo 7A", "Grupo 7B", "Grupo 8A", "Grupo 8B",
    "Grupo 9A", "Grupo 9B", "Grupo 10A", "Grupo 10B", "Grupo 11A",
    "Grupo 11B"
  ]; // 👈 define tus grupos reales

  Future<void> _loadAttendance() async {
    final data = await supabase
        .from('attendance')
        .select('student_id, status, timestamp, students(name, group_name)')
        .eq('students.group_name', selectedGroup)
        .order('timestamp', ascending: false);

    if (!mounted) return; // 👈 evita warnings de context async

    setState(() {
      attendanceList = List<Map<String, dynamic>>.from(data);
    });
  }

  @override
  void initState() {
    super.initState();
    selectedGroup = groups.first; // 👈 inicia con el primer grupo
    _loadAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Asistencia por grupo')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButton<String>(
              value: selectedGroup, // 👈 ya no es nullable
              items: groups.map((g) {
                return DropdownMenuItem(
                  value: g,
                  child: Text(g),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedGroup = value!; // 👈 aseguramos que no sea null
                });
                _loadAttendance();
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: attendanceList.length,
              itemBuilder: (context, index) {
                final record = attendanceList[index];
                final student = record['students'];
                return Card(
                  child: ListTile(
                    title: Text(student['name']),
                    subtitle: Text(
                      'Grupo: ${student['group_name']} | '
                      'Estado: ${record['status']} | '
                      'Hora: ${record['timestamp']}',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
