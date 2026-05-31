import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:habitude/features/goals/screens/goals_list_screen.dart';
import 'package:habitude/shared/auth_repository.dart';
import 'package:habitude/shared/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  // Initialize Foreground Task
  FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: 'timer_channel',
      channelName: 'Timer Notifications',
      channelDescription: 'Ongoing focus timer status',
      channelImportance: NotificationChannelImportance.LOW,
      priority: NotificationPriority.LOW,
    ),
    iosNotificationOptions: const IOSNotificationOptions(
      showNotification: true,
      playSound: false,
    ),
    foregroundTaskOptions: ForegroundTaskOptions(
      eventAction: ForegroundTaskEventAction.nothing(),
      autoRunOnBoot: false,
      allowWakeLock: true,
      allowWifiLock: false,
    ),
  );

  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  final container = ProviderContainer();

  // Initialize Local Notifications with action handler
  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iosInit = DarwinInitializationSettings();
  await FlutterLocalNotificationsPlugin().initialize(
    settings: const InitializationSettings(android: androidInit, iOS: iosInit),
    onDidReceiveNotificationResponse: (response) {
      if (response.actionId == 'check_in') {
        container.read(timerNotifierProvider.notifier).checkIn();
      } else if (response.actionId == 'stop_timer') {
        container.read(timerNotifierProvider.notifier).stopTimer();
      }
    },
  );

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
