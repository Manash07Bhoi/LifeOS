import 'dart:convert';
import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import '../models/goal.dart';
import '../models/habit.dart';
import '../models/focus_session.dart';

class DataExportService {
  static Future<void> exportData() async {
    final Map<String, dynamic> backupData = {
      'version': '1.1.0',
      'goals': Hive.box<Goal>('goalsBox').values.map((g) => _goalToJson(g)).toList(),
      'habits': Hive.box<Habit>('habitsBox').values.map((h) => _habitToJson(h)).toList(),
      'sessions': Hive.box<FocusSession>('sessionsBox').values.map((s) => _sessionToJson(s)).toList(),
    };

    final jsonString = jsonEncode(backupData);
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/lifeos_backup.json');
    await file.writeAsString(jsonString);

    await SharePlus.instance.share(ShareParams(files: [XFile(file.path)], text: 'LifeOS Data Backup'));
  }

  static Future<bool> importData() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        final file = File(result.files.single.path!);
        final jsonString = await file.readAsString();
        final Map<String, dynamic> backupData = jsonDecode(jsonString);

        if (!backupData.containsKey('version')) return false;

        final goalsBox = Hive.box<Goal>('goalsBox');
        final habitsBox = Hive.box<Habit>('habitsBox');
        final sessionsBox = Hive.box<FocusSession>('sessionsBox');

        await goalsBox.clear();
        await habitsBox.clear();
        await sessionsBox.clear();

        if (backupData['goals'] != null) {
          for (var item in backupData['goals']) {
            final goal = _goalFromJson(item);
            await goalsBox.put(goal.id, goal);
          }
        }

        if (backupData['habits'] != null) {
          for (var item in backupData['habits']) {
            final habit = _habitFromJson(item);
            await habitsBox.put(habit.id, habit);
          }
        }

        if (backupData['sessions'] != null) {
          for (var item in backupData['sessions']) {
            final session = _sessionFromJson(item);
            await sessionsBox.add(session);
          }
        }

        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Map<String, dynamic> _goalToJson(Goal g) {
    return {
      'id': g.id,
      'title': g.title,
      'description': g.description,
      'targetDate': g.targetDate.toIso8601String(),
      'progress': g.progress,
      'category': g.category,
      'priority': g.priority,
      'createdAt': g.createdAt.toIso8601String(),
    };
  }

  static Goal _goalFromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      targetDate: DateTime.parse(json['targetDate']),
      progress: json['progress'],
      category: json['category'],
      priority: json['priority'] ?? 'Medium',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  static Map<String, dynamic> _habitToJson(Habit h) {
    return {
      'id': h.id,
      'title': h.title,
      'description': h.description,
      'frequencyDays': h.frequencyDays,
      'completionDates': h.completionDates.map((d) => d.toIso8601String()).toList(),
      'streak': h.streak,
      'notes': h.notes,
      'frequencyType': h.frequencyType,
      'createdAt': h.createdAt.toIso8601String(),
    };
  }

  static Habit _habitFromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      frequencyDays: json['frequencyDays'],
      completionDates: (json['completionDates'] as List).map((d) => DateTime.parse(d)).toList(),
      streak: json['streak'],
      notes: json['notes'] ?? '',
      frequencyType: json['frequencyType'] ?? 'Daily',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  static Map<String, dynamic> _sessionToJson(FocusSession s) {
    return {
      'durationMinutes': s.durationMinutes,
      'startTime': s.startTime.toIso8601String(),
      'endTime': s.endTime.toIso8601String(),
      'relatedGoalId': s.relatedGoalId,
    };
  }

  static FocusSession _sessionFromJson(Map<String, dynamic> json) {
    return FocusSession(
      durationMinutes: json['durationMinutes'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      relatedGoalId: json['relatedGoalId'],
    );
  }
}
