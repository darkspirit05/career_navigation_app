import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/quiz/quiz_screen.dart';
import 'screens/result/result_screen.dart';
import 'screens/history/history_screen.dart';
import 'screens/auth/auth_screen.dart'; // ✅ Use your combined Login/Signup screen

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://kinbrxanwuvdewlqasgt.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtpbmJyeGFud3V2ZGV3bHFhc2d0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAzNTI1OTUsImV4cCI6MjA2NTkyODU5NX0.ws6w_6x9-Z7EenSYa2NTl3nNd_uzqVOtp-Fo7AuVBhw',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Career Navigator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const AuthGate(), // 👈 Auth gate controls access
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/quiz':
            return MaterialPageRoute(builder: (_) => const QuizScreen());

          case '/results':
            return MaterialPageRoute(
              builder: (_) => ResultScreen(
                answers: (settings.arguments as Map<int, String>?) ?? {},
              ),
              settings: settings,
            );

          case '/history':
            return MaterialPageRoute(builder: (_) => const HistoryScreen());

          case '/login': // Optional: if you want to explicitly call it somewhere
            return MaterialPageRoute(builder: (_) => const AuthScreen());

          default:
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(child: Text("Route not found")),
              ),
            );
        }
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = Supabase.instance.client.auth.currentSession;

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return session != null ? const QuizScreen() : const AuthScreen();
      },
    );
  }
}
