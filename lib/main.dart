import 'package:CareerVerse/screens/career/career_detail_screen.dart';
import 'package:CareerVerse/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/quiz/quiz_screen.dart';
import 'screens/result/result_screen.dart';
import 'screens/history/history_screen.dart';
import 'screens/auth/auth_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    print('Flutter error: ${details.exception}');
  };

  try {
    await Supabase.initialize(
      url: 'https://kinbrxanwuvdewlqasgt.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtpbmJyeGFud3V2ZGV3bHFhc2d0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAzNTI1OTUsImV4cCI6MjA2NTkyODU5NX0.ws6w_6x9-Z7EenSYa2NTl3nNd_uzqVOtp-Fo7AuVBhw',
    );
  } catch (e) {
    print('❌ Supabase init failed: $e');
  }

  runApp(
    ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Career Navigator',
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      darkTheme: ThemeData.dark(),
      home: const AuthGate(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/quiz':
            return MaterialPageRoute(
              builder: (_) => const QuizScreen(),
              settings: settings,
            );

          case '/results':
            return MaterialPageRoute(
              builder: (_) => const ResultScreen(),
              settings: settings,
            );

          case '/history':
            return MaterialPageRoute(
              builder: (_) => const HistoryScreen(),
              settings: settings,
            );

          case '/careerDetail':
            final args = settings.arguments as Map<String, dynamic>?;
            if (args != null && args.containsKey('career')) {
              return MaterialPageRoute(
                builder: (_) => CareerDetailScreen(career: args['career']),
                settings: settings,
              );
            } else {
              return _errorRoute("Invalid career detail arguments.");
            }

          case '/login':
            return MaterialPageRoute(
              builder: (_) => const AuthScreen(),
              settings: settings,
            );

          default:
            return _errorRoute("404 - Route not found");
        }
      },
    );
  }

  MaterialPageRoute _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: Center(child: Text(message)),
      ),
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
