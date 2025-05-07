import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/weight_record.dart';
import '../models/user_profile.dart';
import '../services/local_storage_service.dart';
import '../services/weight_record_service.dart';
import 'weight_bmi_chart_screen.dart';
import 'exercise_screen.dart';

class CalendarScreen extends StatefulWidget {
  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, double> _weightMap = {};
  UserProfile? _profile;

  @override
  void initState() {
    super.initState();
    _loadWeightRecords();
    _loadProfile();
  }

  Future<void> _loadWeightRecords() async {
    final records = await WeightRecordService.loadWeightRecords();
    setState(() {
      _weightMap = {
        for (var record in records)
          DateTime(record.date.year, record.date.month, record.date.day): record.weight,
      };
    });
  }

  Future<void> _loadProfile() async {
    final profile = await LocalStorageService.loadUserProfile();
    setState(() {
      _profile = profile;
    });
  }

  Future<void> _openWeightInputDialog(DateTime date) async {
    final controller = TextEditingController();
    final initialWeight = _weightMap[DateTime(date.year, date.month, date.day)];
    if (initialWeight != null) {
      controller.text = initialWeight.toString();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${date.year}년 ${date.month}월 ${date.day}일 몸무게 입력'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: '몸무게 (kg)'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              final weight = double.tryParse(controller.text);
              if (weight != null) {
                final record = WeightRecord(date: date, weight: weight);
                await WeightRecordService.saveWeightRecord(record);
                await _loadWeightRecords();
                Navigator.pop(context);
              }
            },
            child: Text('저장'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // ⛔ 뒤로가기 버튼 제거
        title: Text('운동 일기'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.show_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => WeightBmiChartScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_profile != null)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('👤 ${_profile!.name} 님',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('키: ${_profile!.height} cm / 몸무게: ${_profile!.weight} kg / BMI: ${_profile!.bmi.toStringAsFixed(1)}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                  Divider(thickness: 1),
                ],
              ),
            ),
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) async {
              // 🔒 미래 날짜 차단 (오늘 제외)
              final today = DateTime.now();
              final todayOnly = DateTime(today.year, today.month, today.day);
              final selectedOnly = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);

              if (selectedOnly.isAfter(todayOnly)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('미래 날짜에는 기록할 수 없습니다.')),
                );
                return;
              }


              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });

              final selectedKey = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
              final weight = _weightMap[selectedKey];

              if (weight != null) {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ExerciseScreen(selectedDate: selectedDay),
                  ),
                );
                if (result == true) await _loadWeightRecords();
              } else {
                final controller = TextEditingController();

                final didSave = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('${selectedDay.year}년 ${selectedDay.month}월 ${selectedDay.day}일 몸무게 입력'),
                    content: TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: '몸무게 (kg)'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('취소'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final weight = double.tryParse(controller.text);
                          if (weight != null) {
                            final record = WeightRecord(date: selectedDay, weight: weight);
                            await WeightRecordService.saveWeightRecord(record);
                            await _loadWeightRecords();
                            Navigator.pop(context, true);
                          }
                        },
                        child: Text('저장'),
                      ),
                    ],
                  ),
                );

                if (didSave == true) {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ExerciseScreen(selectedDate: selectedDay),
                    ),
                  );
                  if (result == true) await _loadWeightRecords();
                }
              }
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                final dayKey = DateTime(date.year, date.month, date.day);
                final weight = _weightMap[dayKey];

                // TODO: Replace with actual async exercise count loading (from storage/service)
                final int exerciseCount = 0;

                if (weight != null || exerciseCount > 0) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (weight != null)
                        Text(
                          '${weight.toStringAsFixed(1)}kg',
                          style: TextStyle(fontSize: 10, color: Colors.blue),
                        ),
                      if (exerciseCount > 0)
                        Text(
                          '운동 $exerciseCount개',
                          style: TextStyle(fontSize: 9, color: Colors.green),
                        ),
                    ],
                  );
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),
          if (_selectedDay != null)
            Text(
              '${_selectedDay!.year}년 ${_selectedDay!.month}월 ${_selectedDay!.day}일 선택됨',
              style: TextStyle(fontSize: 18),
            ),
        ],
      ),
    );
  }
}