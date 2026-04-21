import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/security/encryption_service.dart';
import 'data/models/goal.dart';
import 'data/models/habit.dart';
import 'data/models/focus_session.dart';
import 'data/models/command_history.dart';
import 'features/system/splash_screen.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'features/goals/add_edit_goal_screen.dart';
import 'features/habits/add_edit_habit_screen.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    await Hive.initFlutter();

    // Register Adapters
    Hive.registerAdapter(GoalAdapter());
    Hive.registerAdapter(HabitAdapter());
    Hive.registerAdapter(FocusSessionAdapter());
    Hive.registerAdapter(CommandHistoryAdapter());

    // Initialize Encryption
    final cipher = await EncryptionService.getCipher();

    // Open Encrypted Boxes
    await EncryptionService.openEncryptedBox<Goal>('goalsBox', cipher);
    await EncryptionService.openEncryptedBox<Habit>('habitsBox', cipher);
    await EncryptionService.openEncryptedBox<FocusSession>('sessionsBox', cipher);
    await EncryptionService.openEncryptedBox<CommandHistory>('commandHistoryBox', cipher);
    await EncryptionService.openEncryptedBox('settingsBox', cipher);

    runApp(
      const ProviderScope(
        child: LifeOSApp(),
      ),
    );
  }, (error, stack) {
    // Log securely in production. Omit debugPrint logic to comply with security hardening.
  });
}

class LifeOSApp extends ConsumerWidget {
  const LifeOSApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'LifeOS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
      routes: {
        '/add_goal': (context) => const AddEditGoalScreen(),
        '/add_habit': (context) => const AddEditHabitScreen(),
      },
    );
  }
}
