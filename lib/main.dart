import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitude/features/goals/screens/goals_list_screen.dart';
import 'package:habitude/shared/auth_repository.dart';
import 'package:habitude/shared/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  final container = ProviderContainer();
  try {
    await container.read(authRepositoryProvider).signInAnonymously();
  } catch (e) {
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
      theme: AppTheme.light,
      home: const GoalsListScreen(),
    );
  }
}
