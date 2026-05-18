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
  runApp(const ChecadorApp());
}

class ChecadorApp extends StatelessWidget {
  const ChecadorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Checador Escolar',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/mainMenu': (context) => const MainMenuScreen(),
        '/scanQr': (context) => const ScanQrScreen(),
        '/menu': (context) => const MainMenuScreen(),
        '/createStudent': (context) => const CreateStudentScreen(),
        '/downloadInfo': (context) => const DownloadInfoScreen(),
        '/searchStudent': (context) => const SearchStudentScreen(),


      },
    );
  }
}
