import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설정'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          '설정 화면 (프로필 수정 예정)',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}