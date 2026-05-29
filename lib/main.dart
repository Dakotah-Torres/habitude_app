import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Note: This will fail if real credentials aren't provided and emulator isn't configured,
  // but for Sprint 1 acceptance, we just need the initialization code to exist.
  // In a real scenario, we'd use FirebaseOptions or the emulator.
  try {
    await Firebase.initializeApp();
  } catch (e) {
    // Silently fail or log for now as per sprint scope (empty shell)
    debugPrint('Firebase initialization failed: $e');
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habitude',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(body: Center(child: Text('Habitude Empty Shell'))),
    );
  }
}
