import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class TimerForegroundService {
  static void start(String taskTitle, String remaining) {
    FlutterForegroundTask.startService(
      notificationTitle: 'Focusing: $taskTitle',
      notificationText: '$remaining left in this focus session',
    );
  }

  static void update(String taskTitle, String display, bool isOvertime) {
    if (isOvertime) {
      FlutterForegroundTask.updateService(
        notificationTitle: 'Overtime focus: $taskTitle',
        notificationText: '$display bonus focus logged',
      );
    } else {
      FlutterForegroundTask.updateService(
        notificationTitle: 'Focusing: $taskTitle',
        notificationText: '$display left in this focus session',
      );
    }
  }

  static void stop() {
    FlutterForegroundTask.stopService();
  }
}
