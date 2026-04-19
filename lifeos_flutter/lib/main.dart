import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'data/models/goal.dart';
import 'data/models/habit.dart';
import 'data/models/focus_session.dart';
import 'data/models/command_history.dart';
import 'features/system/splash_screen.dart';
import 'features/goals/add_edit_goal_screen.dart';
import 'features/habits/add_edit_habit_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register Adapters
  Hive.registerAdapter(GoalAdapter());
  Hive.registerAdapter(HabitAdapter());
  Hive.registerAdapter(FocusSessionAdapter());
  Hive.registerAdapter(CommandHistoryAdapter());

  // Open Boxes
  await Hive.openBox<Goal>('goalsBox');
  await Hive.openBox<Habit>('habitsBox');
  await Hive.openBox<FocusSession>('sessionsBox');
  await Hive.openBox<CommandHistory>('commandHistoryBox');
  await Hive.openBox('settingsBox');

  runApp(
    const ProviderScope(
      child: LifeOSApp(),
    ),
  );
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
