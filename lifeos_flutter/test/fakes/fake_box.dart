import 'package:hive/hive.dart';

class FakeBox<T> implements Box<T> {
  final Map<dynamic, T> _data = {};

  @override
  Iterable<T> get values => _data.values;

  @override
  T? get(dynamic key, {T? defaultValue}) {
    return _data[key] ?? defaultValue;
  }

  @override
  Future<void> put(dynamic key, T value) async {
    _data[key] = value;
  }

  @override
  Future<void> delete(dynamic key) async {
    _data.remove(key);
  }

  @override
  Future<int> clear() async {
    int count = _data.length;
    _data.clear();
    return count;
  }

  // Unimplemented members required by Box interface
  @override
  String get name => throw UnimplementedError();

  @override
  bool get isOpen => true;

  @override
  String? get path => throw UnimplementedError();

  @override
  bool get lazy => throw UnimplementedError();

  @override
  Iterable<dynamic> get keys => _data.keys;

  @override
  int get length => _data.length;

  @override
  bool get isEmpty => _data.isEmpty;

  @override
  bool get isNotEmpty => _data.isNotEmpty;

  @override
  Iterable<T> valuesBetween({dynamic startKey, dynamic endKey}) =>
      throw UnimplementedError();

  @override
  T? getAt(int index) => throw UnimplementedError();

  @override
  Map<dynamic, T> toMap() => Map.of(_data);

  @override
  dynamic keyAt(int index) => throw UnimplementedError();

  @override
  Stream<BoxEvent> watch({dynamic key}) => throw UnimplementedError();

  @override
  bool containsKey(dynamic key) => _data.containsKey(key);

  @override
  Future<void> putAt(int index, T value) => throw UnimplementedError();

  @override
  Future<void> putAll(Map<dynamic, T> entries) async {
    _data.addAll(entries);
  }

  @override
  Future<int> add(T value) async {
    final key = _data.length;
    _data[key] = value;
    return key;
  }

  @override
  Future<Iterable<int>> addAll(Iterable<T> values) async {
    final keys = <int>[];
    for (var value in values) {
      keys.add(await add(value));
    }
    return keys;
  }

  @override
  Future<void> deleteAt(int index) => throw UnimplementedError();

  @override
  Future<void> deleteAll(Iterable<dynamic> keys) async {
    for (var key in keys) {
      _data.remove(key);
    }
  }

  @override
  Future<void> compact() async {}

  @override
  Future<void> close() async {}

  @override
  Future<void> deleteFromDisk() async {
    _data.clear();
  }

  @override
  Future<void> flush() async {}
}
