import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';
import '../command/command_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../goals/goals_screen.dart';
import '../habits/habit_matrix_screen.dart';
import '../analytics/analytics_screen.dart';
import '../settings/settings_screen.dart';
import '../system/quick_actions_panel.dart';
import '../goals/add_edit_goal_screen.dart';
import '../habits/add_edit_habit_screen.dart';
import '../focus/focus_screen.dart';
import '../profile/profile_screen.dart';
import '../../shared/components/confirmation_dialog.dart';
import 'dart:ui';

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
    const ProfileScreen(),
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (_currentIndex != 0) {
          setState(() => _currentIndex = 0);
          return;
        }

        final bool? shouldExit = await ConfirmationDialog.show(
          context,
          title: 'EXIT SYSTEM?',
          message: 'Are you sure you want to exit LifeOS?',
          isDestructive: false,
          confirmText: 'EXIT',
        );

        if (shouldExit == true && context.mounted) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        extendBody: true,
        drawer: _buildDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Builder(
            builder: (ctx) => IconButton(
              tooltip: 'Open menu',
              icon: const Icon(Icons.menu, color: AppTheme.textPrimary),
              onPressed: () => Scaffold.of(ctx).openDrawer(),
            ),
          ),
        ),
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
        child: Tooltip(
          message: 'Command Center (Long press for Quick Actions)',
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
      ),
        bottomNavigationBar: _buildModernBottomBar(),
      ),
    );
  }

  Widget _buildModernBottomBar() {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      decoration: BoxDecoration(
        color: AppTheme.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(Icons.dashboard_outlined, Icons.dashboard, 0, 'Dashboard'),
                _buildNavItem(Icons.track_changes_outlined, Icons.track_changes, 1, 'Goals'),
                const SizedBox(width: 48), // Space for FAB
                _buildNavItem(Icons.bar_chart_outlined, Icons.bar_chart, 3, 'Analytics'),
                _buildNavItem(Icons.person_outline, Icons.person, 4, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, IconData activeIcon, int index, String tooltipText) {
    final isActive = _currentIndex == index;
    return Tooltip(
      message: tooltipText,
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutExpo,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isActive ? AppTheme.primaryPurple.withValues(alpha: 0.2) : Colors.transparent,
            shape: BoxShape.circle,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppTheme.primaryPurple.withValues(alpha: 0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    )
                  ]
                : [],
          ),
          child: Icon(
            isActive ? activeIcon : icon,
            color: isActive ? AppTheme.primaryPurple : AppTheme.textSecondary,
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          color: AppTheme.background.withValues(alpha: 0.8),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'SYSTEM\nMODULES',
                    style: TextStyle(
                      color: AppTheme.neonCyan,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const Divider(color: Colors.white12),
                _buildDrawerItem(Icons.dashboard, 'Dashboard', () {
                  Navigator.pop(context);
                  setState(() => _currentIndex = 0);
                }),
                _buildDrawerItem(Icons.track_changes, 'Goals', () {
                  Navigator.pop(context);
                  setState(() => _currentIndex = 1);
                }),
                _buildDrawerItem(Icons.loop, 'Habits', () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const HabitMatrixScreen()));
                }),
                _buildDrawerItem(Icons.timer, 'Focus Mode', () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const FocusScreen()));
                }),
                _buildDrawerItem(Icons.bar_chart, 'Analytics', () {
                  Navigator.pop(context);
                  setState(() => _currentIndex = 3);
                }),
                _buildDrawerItem(Icons.terminal, 'Command Terminal', () {
                  Navigator.pop(context);
                  _openCommandCenter();
                }),
                _buildDrawerItem(Icons.person, 'Profile', () {
                  Navigator.pop(context);
                  setState(() => _currentIndex = 4);
                }),
                const Spacer(),
                const Divider(color: Colors.white12),
                _buildDrawerItem(Icons.settings, 'Settings', () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
                }),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.textSecondary),
      title: Text(
        title,
        style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16),
      ),
      onTap: onTap,
    );
  }
}
