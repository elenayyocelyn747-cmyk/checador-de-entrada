import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/register_screen.dart';
import 'presentation/screens/main_menu_screen.dart';
import 'presentation/screens/scan_qr_screen.dart';
import 'presentation/screens/download_info_screen.dart';
import 'presentation/screens/search_student_screen.dart';
import 'presentation/screens/create_student.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://iqjlvnsjihrpyhhtvqlw.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlxamx2bnNqaWhycHloaHR2cWx3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY5NjQ5NTAsImV4cCI6MjA5MjU0MDk1MH0.xdK8e94EpTNuDm7YaXadrY8zTAgA1MXhxTOszo-EiAs',
  );

  final session = Supabase.instance.client.auth.currentSession;

  runApp(ChecadorApp(initialSession: session));
}

class ChecadorApp extends StatelessWidget {
  final Session? initialSession;
  const ChecadorApp({super.key, this.initialSession});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Checador Escolar',
      theme: ThemeData(
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue,
          secondary: Colors.purple,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          prefixIconColor: Colors.blue,
        ),
      ),
      initialRoute: initialSession != null ? '/mainMenu' : '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/mainMenu': (context) => const MainMenuScreen(),
        '/scanQr': (context) => const ScanQrScreen(),
        '/createStudent': (context) => const CreateStudentScreen(),
        '/downloadInfo': (context) => const DownloadInfoScreen(),
        '/searchStudent': (context) => const SearchStudentScreen(),
      },
    );
  }
}
