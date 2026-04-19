import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../command/command_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../goals/goals_screen.dart';
import '../habits/habit_matrix_screen.dart';
import '../analytics/analytics_screen.dart';
import '../settings/settings_screen.dart';
import '../../shared/widgets/quick_actions_panel.dart';
import '../goals/add_edit_goal_screen.dart';
import '../habits/add_edit_habit_screen.dart';
import '../focus/focus_screen.dart';

class NavigationWrapperScreen extends StatefulWidget {
  const NavigationWrapperScreen({super.key});

  @override
  State<NavigationWrapperScreen> createState() => _NavigationWrapperScreenState();
}

class _NavigationWrapperScreenState extends State<NavigationWrapperScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const GoalsScreen(),
    const HabitMatrixScreen(),
    const AnalyticsScreen(),
    const SettingsScreen(),
  ];

  void _openQuickActions() {
    QuickActionsPanel.show(
      context,
      onAddGoal: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEditGoalScreen()));
      },
      onAddHabit: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEditHabitScreen()));
      },
      onStartFocus: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const FocusScreen()));
      },
      onViewAnalytics: () {
        setState(() => _currentIndex = 3);
      },
    );
  }

  void _openCommandCenter() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Command Center',
      barrierColor: Colors.black87,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const CommandScreen();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutExpo,
          )),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.neonCyan.withValues(alpha: 0.3),
              blurRadius: 20,
              spreadRadius: 2,
            )
          ],
        ),
        child: GestureDetector(
          onLongPress: _openQuickActions,
          child: FloatingActionButton(
            onPressed: _openCommandCenter,
            backgroundColor: AppTheme.surfaceElevated,
            child: const Icon(
              Icons.terminal,
              color: AppTheme.neonCyan,
            ),
          ),
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: AppTheme.surface,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppTheme.primaryPurple,
          unselectedItemColor: AppTheme.textSecondary,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.track_changes_outlined),
              activeIcon: Icon(Icons.track_changes),
              label: 'Goals',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.loop),
              label: 'Habits',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart),
              label: 'Analytics',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
