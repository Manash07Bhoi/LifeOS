import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/neon_text.dart';
import '../../providers/focus_provider.dart';
import '../../providers/habits_provider.dart';
import '../../data/models/focus_session.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(focusSessionsProvider);
    final habits = ref.watch(habitsProvider);

    int totalFocusMinutes = sessions.fold(0, (sum, session) => sum + session.durationMinutes);
    int totalHabitsCompleted = habits.fold(0, (sum, habit) => sum + habit.completionDates.length);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const NeonText('SYSTEM ANALYTICS', color: AppTheme.textPrimary, glow: false),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: GlassCard(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.timer, color: AppTheme.neonCyan),
                          const SizedBox(height: 16),
                          Text(
                            '$totalFocusMinutes',
                            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                          ),
                          const Text('Total Focus (min)', style: TextStyle(color: AppTheme.textSecondary)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GlassCard(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle_outline, color: AppTheme.primaryPurple),
                          const SizedBox(height: 16),
                          Text(
                            '$totalHabitsCompleted',
                            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                          ),
                          const Text('Habits Completed', style: TextStyle(color: AppTheme.textSecondary)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text('FOCUS TRAJECTORY (LAST 7 DAYS)', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, letterSpacing: 1.5)),
              const SizedBox(height: 16),
              if (sessions.isEmpty)
                const GlassCard(
                  padding: EdgeInsets.all(48),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bar_chart, color: AppTheme.textSecondary, size: 48),
                        SizedBox(height: 16),
                        Text(
                          'No Data Yet',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Complete sessions to see analytics',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                )
              else
                GlassCard(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: AppTheme.textSecondary.withValues(alpha: 0.1),
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 22,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text('D${value.toInt()}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 10)),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 30,
                              getTitlesWidget: (value, meta) {
                                return Text('${value.toInt()}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 10));
                              },
                              reservedSize: 28,
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: _generateFocusSpots(sessions),
                            isCurved: true,
                            color: AppTheme.neonCyan,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: AppTheme.neonCyan.withValues(alpha: 0.1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.surfaceElevated,
                    foregroundColor: AppTheme.primaryPurple,
                    side: const BorderSide(color: AppTheme.primaryPurple),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const DetailedStatsScreen()));
                  },
                  child: const Text('VIEW DETAILED TELEMETRY'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<FlSpot> _generateFocusSpots(List<FocusSession> sessions) {
    // Generate real data aggregation for the last 7 days
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Create a map to hold total minutes per day for the last 7 days
    Map<int, int> dailyMinutes = {};
    for (int i = 0; i < 7; i++) {
      dailyMinutes[i] = 0; // Initialize with 0
    }

    for (var session in sessions) {
      final sessionDay = DateTime(session.startTime.year, session.startTime.month, session.startTime.day);
      final difference = today.difference(sessionDay).inDays;

      // If the session is within the last 7 days (0 = today, 6 = 6 days ago)
      if (difference >= 0 && difference < 7) {
        // Map 0 -> today (index 6), 1 -> yesterday (index 5), ..., 6 -> 6 days ago (index 0)
        final index = 6 - difference;
        dailyMinutes[index] = (dailyMinutes[index] ?? 0) + session.durationMinutes;
      }
    }

    return List.generate(7, (index) => FlSpot(index.toDouble(), dailyMinutes[index]?.toDouble() ?? 0.0));
  }
}

class DetailedStatsScreen extends StatelessWidget {
  const DetailedStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const NeonText('DETAILED TELEMETRY', color: AppTheme.textPrimary, glow: false),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.analytics, size: 64, color: AppTheme.primaryPurple),
              const SizedBox(height: 24),
              Text(
                'Data Aggregation in Progress',
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Advanced statistical modeling will be available in future core updates.',
                style: TextStyle(color: AppTheme.textSecondary),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
