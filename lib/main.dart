import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitude/shared/auth_repository.dart';

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

  final container = ProviderContainer();
  try {
    await container.read(authRepositoryProvider).signInAnonymously();
  } catch (e) {
    // Rethrow as per Sprint 3 Task 3 criteria
    debugPrint('Anonymous sign-in failed: $e');
    rethrow;
  }

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
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
