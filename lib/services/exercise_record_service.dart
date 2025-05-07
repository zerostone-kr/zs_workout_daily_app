import 'dart:collection';

class ExerciseRecordService {
  static final Map<DateTime, int> _exerciseCountMap = HashMap();

  /// 해당 날짜의 운동 기록 개수를 반환합니다.
  static int getExerciseCountForDate(DateTime date) {
    final key = DateTime(date.year, date.month, date.day);
    return _exerciseCountMap[key] ?? 0;
  }

  /// 특정 날짜의 운동 개수를 설정합니다.
  static void setExerciseCountForDate(DateTime date, int count) {
    final key = DateTime(date.year, date.month, date.day);
    _exerciseCountMap[key] = count;
  }

  /// (선택) 모든 기록을 초기화합니다. 디버깅 용도
  static void clearAll() {
    _exerciseCountMap.clear();
  }
}