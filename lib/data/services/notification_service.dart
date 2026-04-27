import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification click
      },
    );
  }

  Future<void> scheduleWarrantyReminder(
      int id, String title, DateTime expiryDate) async {
    // Schedule reminder 30 days before expiry
    final reminderDate = expiryDate.subtract(const Duration(days: 30));
    
    if (reminderDate.isBefore(DateTime.now())) {
      // If expiry is less than 30 days away, remind tomorrow morning
      // or skip if already expired.
      return;
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'Warranty Reminder: $title',
      'Your warranty for $title will expire in 30 days.',
      tz.TZDateTime.from(reminderDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'warranty_reminder_channel',
          'Warranty Reminders',
          channelDescription: 'Notifications for expiring warranties',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
