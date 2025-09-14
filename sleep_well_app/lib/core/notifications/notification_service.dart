import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  
  static bool _initialized = false;
  
  static Future<void> initialize() async {
    if (_initialized) return;
    
    // Initialize timezone
    tz.initializeTimeZones();
    
    // Android initialization settings
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // iOS initialization settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
    
    _initialized = true;
  }
  
  static void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap - navigate to appropriate screen
    // This will be implemented with proper navigation
  }
  
  static Future<bool> requestPermissions() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }
  
  static Future<bool> hasPermissions() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }
  
  // Schedule bedtime reminder (T-30m)
  static Future<void> scheduleBedtimeReminder({
    required DateTime bedtime,
    required String timezone,
  }) async {
    await _notifications.cancel(1); // Cancel existing reminder
    
    final reminderTime = bedtime.subtract(const Duration(minutes: 30));
    
    await _notifications.zonedSchedule(
      1,
      "Let's wind down.",
      '1 min ritual, then sleep better.',
      tz.TZDateTime.from(reminderTime, tz.getLocation(timezone)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'bedtime_reminder',
          'Bedtime Reminders',
          channelDescription: 'Gentle reminders to start your wind-down routine',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
  
  // Schedule past-bedtime nudge
  static Future<void> schedulePastBedtimeNudge({
    required DateTime bedtime,
    required String timezone,
  }) async {
    await _notifications.cancel(2); // Cancel existing nudge
    
    final nudgeTime = bedtime.add(const Duration(minutes: 15));
    
    await _notifications.zonedSchedule(
      2,
      'Still up?',
      '60 seconds to calm your mind.',
      tz.TZDateTime.from(nudgeTime, tz.getLocation(timezone)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'past_bedtime_nudge',
          'Past Bedtime Nudges',
          channelDescription: "Gentle nudges when you're past your bedtime",
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
  
  // Cancel all notifications
  static Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
  
  // Cancel specific notification
  static Future<void> cancel(int id) async {
    await _notifications.cancel(id);
  }
}
