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
        .select('students(name, group_name), status, timestamp')
        .eq('students.group_name', group);

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
                onPressed: () => _loadAttendance(g),
                child: Text('Grupo $g'),
              );
            }).toList(),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: attendance.length,
              itemBuilder: (context, index) {
                final item = attendance[index];
                return ListTile(
                  title: Text(item['students']['name']),
                  subtitle: Text(
                    'Grupo: ${item['students']['group_name']} | '
                    'Estado: ${item['status']} | '
                    'Fecha: ${item['timestamp']}',
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
