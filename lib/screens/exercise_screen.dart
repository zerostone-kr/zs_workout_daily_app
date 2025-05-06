import 'package:flutter/material.dart';

class ExerciseScreen extends StatelessWidget {
  final DateTime selectedDate;

  const ExerciseScreen({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${selectedDate.year}-${selectedDate.month}-${selectedDate.day} 운동 기록'),
        leading: BackButton(onPressed: () {
          Navigator.pop(context, true); // true 반환
        }),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          '운동 기록 입력 화면\n선택된 날짜: ${selectedDate.toLocal().toString().split(" ")[0]}',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}