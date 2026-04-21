import 'package:hive/hive.dart';

class FakeBox<T> implements Box<T> {
  final Map<dynamic, T> _data = {};

  @override
  Iterable<T> get values => _data.values;

  @override
  Future<void> put(dynamic key, T value) async {
    _data[key] = value;
  }

  @override
  Future<void> delete(dynamic key) async {
    _data.remove(key);
  }

  @override
  T? get(dynamic key, {T? defaultValue}) {
    return _data[key] ?? defaultValue;
  }

  @override
  Future<void> clear() async {
    _data.clear();
  }

  @override
  bool containsKey(dynamic key) => _data.containsKey(key);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
