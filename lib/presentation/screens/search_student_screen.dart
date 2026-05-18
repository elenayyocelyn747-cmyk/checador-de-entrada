import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SearchStudentScreen extends StatefulWidget {
  const SearchStudentScreen({super.key});

  @override
  State<SearchStudentScreen> createState() => _SearchStudentScreenState();
}

class _SearchStudentScreenState extends State<SearchStudentScreen> {
  final supabase = Supabase.instance.client;
  final searchController = TextEditingController();
  List<Map<String, dynamic>> results = [];

  /// Buscar alumnos por nombre y traer id, name, group_name
  Future<void> _searchStudent() async {
    final data = await supabase
        .from('students')
        .select('id, name, group_name') // 👈 incluye el id
        .ilike('name', '%${searchController.text.trim()}%');

    setState(() {
      results = List<Map<String, dynamic>>.from(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar Alumno')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Nombre del alumno',
                suffixIcon: Icon(Icons.search),
              ),
              onSubmitted: (_) => _searchStudent(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final student = results[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(student['name'],
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text('Grupo: ${student['group_name']}'),
                          const SizedBox(height: 10),
                          Center(
                            child: SizedBox(
                              width: 150,
                              height: 150,
                              child: QrImageView(
                                data: student['id'], // 👈 QR con el UUID único
                                version: QrVersions.auto,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
