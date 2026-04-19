import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lifeos_flutter/main.dart' as app;
import 'package:lifeos_flutter/shared/widgets/glow_button.dart';
import 'package:lifeos_flutter/shared/widgets/custom_input_field.dart';
import 'package:lifeos_flutter/data/models/goal.dart';
import 'package:lifeos_flutter/data/models/habit.dart';
import 'package:lifeos_flutter/data/models/focus_session.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Clear Hive before the test to ensure a clean state
  setUpAll(() async {
    await Hive.initFlutter();
    Hive.registerAdapter(GoalAdapter());
    Hive.registerAdapter(HabitAdapter());
    Hive.registerAdapter(FocusSessionAdapter());

    await Hive.openBox<Goal>('goalsBox');
    await Hive.openBox<Habit>('habitsBox');
    await Hive.openBox<FocusSession>('sessionsBox');
    await Hive.openBox('commandHistoryBox');
    await Hive.openBox('settingsBox');

    await Hive.box<Goal>('goalsBox').clear();
    await Hive.box<Habit>('habitsBox').clear();
    await Hive.box<FocusSession>('sessionsBox').clear();
    await Hive.box('commandHistoryBox').clear();
    await Hive.box('settingsBox').clear();
  });

  testWidgets('LifeOS Full E2E Journey', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Wait for Splash to transition
    await Future.delayed(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // 1. Onboarding
    final initButton = find.widgetWithText(GlowButton, 'INITIALIZE SYSTEM');
    expect(initButton, findsOneWidget);
    await tester.tap(initButton);
    await tester.pumpAndSettle();

    // 2. Verify Dashboard
    expect(find.text('SYSTEM STATUS'), findsOneWidget);

    // 3. Command System & Quick Navigation
    final fab = find.byIcon(Icons.terminal);
    await tester.tap(fab);
    await tester.pumpAndSettle();

    final commandInput = find.byType(TextField);
    expect(commandInput, findsOneWidget);

    await tester.enterText(commandInput, 'add goal');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    // Verify we are on Add Goal screen
    expect(find.text('ESTABLISH NEW PROTOCOL'), findsOneWidget);

    // 4. Add Goal Flow
    final goalTitleInput = find.byType(CustomInputField).first;
    await tester.enterText(goalTitleInput, 'E2E Test Goal');

    final saveGoalBtn = find.widgetWithText(GlowButton, 'INITIALIZE PROTOCOL');
    await tester.tap(saveGoalBtn);
    await tester.pumpAndSettle();

    // Back to Dashboard, but Command Screen was opened from there.
    // Ensure we tap Dashboard tab just in case
    final dashboardTab = find.byIcon(Icons.dashboard_outlined);
    await tester.tap(dashboardTab);
    await tester.pumpAndSettle();
    expect(find.text('E2E Test Goal'), findsOneWidget);

    // 5. Habits Flow
    final habitsTab = find.byIcon(Icons.loop);
    await tester.tap(habitsTab);
    await tester.pumpAndSettle();
    expect(find.text('HABIT MATRIX'), findsOneWidget);

    // Quick Action to add Habit
    await tester.longPress(fab);
    await tester.pumpAndSettle();

    final addHabitAction = find.text('Add Habit');
    expect(addHabitAction, findsOneWidget);
    await tester.tap(addHabitAction);
    await tester.pumpAndSettle();

    final habitTitleInput = find.byType(CustomInputField).first;
    await tester.enterText(habitTitleInput, 'E2E Test Habit');
    final saveHabitBtn = find.widgetWithText(GlowButton, 'INITIALIZE HABIT');
    await tester.tap(saveHabitBtn);
    await tester.pumpAndSettle();
    expect(find.text('E2E Test Habit'), findsWidgets); // Found on habits screen

    // 6. Focus Timer Flow
    await tester.longPress(fab);
    await tester.pumpAndSettle();
    final startFocusAction = find.text('Start Focus');
    await tester.tap(startFocusAction);
    await tester.pumpAndSettle();

    expect(find.text('DEEP FOCUS'), findsOneWidget);
    final initiateFocus = find.widgetWithText(GlowButton, 'INITIATE');
    await tester.tap(initiateFocus);
    await tester.pumpAndSettle();

    // Timer running
    expect(find.widgetWithText(GlowButton, 'PAUSE'), findsOneWidget);

    // We can't easily wait 25 minutes in a test, so we'll pause and exit
    final pauseFocus = find.widgetWithText(GlowButton, 'PAUSE');
    await tester.tap(pauseFocus);
    await tester.pumpAndSettle();

    final backBtn = find.byIcon(Icons.arrow_back);
    await tester.tap(backBtn);
    await tester.pumpAndSettle();

    final abortBtn = find.text('ABORT');
    await tester.tap(abortBtn);
    await tester.pumpAndSettle();

    // 7. Settings & Reset Flow
    final settingsTab = find.byIcon(Icons.settings_outlined);
    await tester.tap(settingsTab);
    await tester.pumpAndSettle();

    final purgeBtn = find.text('Purge System Data');
    await tester.ensureVisible(purgeBtn);
    await tester.tap(purgeBtn);
    await tester.pumpAndSettle();

    final confirmPurgeBtn = find.text('PURGE');
    await tester.tap(confirmPurgeBtn);
    await tester.pumpAndSettle();

    // Verify app reset back to Dashboard, checking if data is wiped
    expect(find.text('SYSTEM STATUS'), findsOneWidget);
    expect(find.text('No active goals detected.'), findsOneWidget);
  });
}
