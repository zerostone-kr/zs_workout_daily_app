import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/weight_record.dart';

class WeightRecordService {
  static const String weightRecordsKey = 'weightRecords';

  static Future<void> saveWeightRecord(WeightRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final recordList = await loadWeightRecords();
    final existingIndex = recordList.indexWhere(
      (r) => r.date.year == record.date.year &&
             r.date.month == record.date.month &&
             r.date.day == record.date.day,
    );

    if (existingIndex != -1) {
      recordList[existingIndex] = record;
    } else {
      recordList.add(record);
    }

    final recordJsonList = recordList.map((e) => e.toJson()).toList();
    await prefs.setString(weightRecordsKey, jsonEncode(recordJsonList));
  }

  static Future<List<WeightRecord>> loadWeightRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final recordString = prefs.getString(weightRecordsKey);
    if (recordString == null) return [];

    final List<dynamic> decoded = jsonDecode(recordString);
    return decoded.map((e) => WeightRecord.fromJson(e)).toList();
  }
}
