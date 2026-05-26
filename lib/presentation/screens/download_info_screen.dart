import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DownloadInfoScreen extends StatefulWidget {
  const DownloadInfoScreen({super.key});

  @override
  State<DownloadInfoScreen> createState() => _DownloadInfoScreenState();
}

class _DownloadInfoScreenState extends State<DownloadInfoScreen> {
  final supabase = Supabase.instance.client;
  List<String> groups = [];
  List<Map<String, dynamic>> attendance = [];

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  /// Cargar lista de grupos únicos desde la tabla students
  Future<void> _loadGroups() async {
    final data = await supabase
        .from('students')
        .select('group_name')
        .order('group_name', ascending: true);

    final uniqueGroups =
        data.map((row) => row['group_name'] as String).toSet().toList();

    setState(() {
      groups = uniqueGroups;
    });
  }

  /// Cargar asistencia filtrada por grupo
  Future<void> _loadAttendance(String group) async {
    final data = await supabase
        .from('attendance')
        .select('student_id, status, timestamp, students(name, group_name)')
        .filter('students.group_name', 'eq', group)
        .order('timestamp', ascending: false);

    setState(() {
      attendance = List<Map<String, dynamic>>.from(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Descargar Información')),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: groups.map((g) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white, // 👈 texto blanco
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onPressed: () => _loadAttendance(g),
                child: Text('Grupo $g'),
              );
            }).toList(),
          ),
          const Divider(),
          Expanded(
            child: attendance.isEmpty
                ? const Center(
                    child: Text(
                      'Sin datos',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: attendance.length,
                    itemBuilder: (context, index) {
                      final item = attendance[index];
                      final student = item['students'];

                      if (student == null) return const SizedBox.shrink();

                      final name = student['name'];
                      final groupName = student['group_name'];
                      final status = item['status'];
                      final timestamp = item['timestamp'];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: const Icon(Icons.person, color: Colors.blue),
                          title: Text(
                            name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Text(
                            'Grupo: $groupName\nEstado: $status\nFecha: $timestamp',
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
