import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weight_record.dart';

class WeightRecordService {
  static const _key = 'weight_records';

  static Future<void> saveWeightRecord(WeightRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final records = await loadWeightRecords();

    // 기존 기록 중 같은 날짜 제거
    records.removeWhere((r) =>
        r.date.year == record.date.year &&
        r.date.month == record.date.month &&
        r.date.day == record.date.day);

    records.add(record);

    final encoded = jsonEncode(records.map((r) => r.toJson()).toList());
    await prefs.setString(_key, encoded);
  }

  static Future<List<WeightRecord>> loadWeightRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);

    if (data == null) return [];

    final List<dynamic> decoded = jsonDecode(data);
    return decoded.map((e) => WeightRecord.fromJson(e)).toList();
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
