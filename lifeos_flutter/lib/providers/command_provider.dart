import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/models/command_history.dart';

class CommandNotifier extends StateNotifier<List<CommandHistory>> {
  final Box<CommandHistory> _box;

  CommandNotifier(this._box) : super(_box.values.toList().reversed.toList());

  void addCommand(String text, {bool wasSuccessful = true}) {
    final cmd = CommandHistory(
      commandText: text,
      executedAt: DateTime.now(),
      wasSuccessful: wasSuccessful,
    );
    _box.add(cmd);

    // Keep it ordered by newest first
    final list = _box.values.toList();
    list.sort((a, b) => b.executedAt.compareTo(a.executedAt));
    state = list;
  }
}

final commandProvider =
    StateNotifierProvider<CommandNotifier, List<CommandHistory>>((ref) {
      final box = Hive.box<CommandHistory>('commandHistoryBox');
      return CommandNotifier(box);
    });
