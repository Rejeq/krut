import 'dart:convert';
import 'package:track_dev/core/models/stopwatch_state.dart';
import 'package:track_dev/core/repository/time.dart';
import 'package:track_dev/data/source/local/local_storage_source.dart';
import 'package:track_dev/data/map/stopwatch.dart';

class LocalTimeRepository implements TimeRepository {
  final LocalStorageSource _localStorage;

  static const _keyStopwatchList = 'stopwatch.list';
  static const _keyUniqueId = 'stopwatch.unique_id';

  LocalTimeRepository(this._localStorage);

  @override
  Future<StopwatchState> getStopwatch(int id) async {
    final list = await getAllStopwatch();
    return list.firstWhere(
      (element) => element.id == id,
      orElse: () => throw Exception('Stopwatch not found'),
    );
  }

  @override
  Future<List<StopwatchState>> getAllStopwatch() async {
    final jsonStr = await _localStorage.read(_keyStopwatchList);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list.map((item) {
        return stopwatchStateFromJson(Map<String, dynamic>.from(item as Map));
      }).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> upsertStopwatch(StopwatchState state) async {
    final list = await getAllStopwatch();
    final index = list.indexWhere((element) => element.id == state.id);
    if (index >= 0) {
      list[index] = state;
    } else {
      list.add(state);
    }
    await _saveAll(list);
  }

  @override
  Future<void> removeStopwatch(int id) async {
    final list = await getAllStopwatch();
    list.removeWhere((element) => element.id == id);
    await _saveAll(list);
  }

  @override
  Future<int> acquireUniqueId() async {
    final valStr = await _localStorage.read(_keyUniqueId);
    int currentId = 1;
    if (valStr != null) {
      currentId = int.tryParse(valStr) ?? 1;
    }
    await _localStorage.write(_keyUniqueId, (currentId + 1).toString());
    return currentId;
  }

  @override
  Future<void> releaseUniqueId(int id) async {
    // No-op for simple auto-increment
  }

  Future<void> _saveAll(List<StopwatchState> list) async {
    final jsonList = list.map((state) => state.toJson()).toList();
    await _localStorage.write(_keyStopwatchList, jsonEncode(jsonList));
  }
}
