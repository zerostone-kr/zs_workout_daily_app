import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/exercise_record_service.dart'; // hypothetical service

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  Map<DateTime, double> _weightMap = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: DateTime.now(),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            final dayKey = DateTime(date.year, date.month, date.day);
            final weight = _weightMap[dayKey];
            final exerciseCount = ExerciseRecordService.getExerciseCountForDate(dayKey); // returns int

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
    );
  }
}
