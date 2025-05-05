import 'package:flutter/material.dart';

class ExerciseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('운동 즐겨찾기'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          '운동 즐겨찾기 등록 화면 (v0.2 예정)',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}