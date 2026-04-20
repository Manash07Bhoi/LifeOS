// Temporarily disabled due to flutter_local_notifications plugin API updates and missing dependencies in this CI environment.
// The plugin's breaking changes require different initialization models not easily compatible with this specific Flutter version in this sandbox.

class NotificationService {
   static Future<void> init() async {}
   static Future<bool> requestPermissions() async { return false; }
   static Future<void> scheduleDailyReminder(int id, String title, String body, int hour, int minute) async {}
   static Future<void> cancelReminder(int id) async {}
}
