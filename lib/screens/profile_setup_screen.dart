import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/local_storage_service.dart';
import '../screens/calendar_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  String? _gender;
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await LocalStorageService.loadUserProfile();
    if (profile != null) {
      setState(() {
        _gender = profile.gender;
        _nameController.text = profile.name;
        _ageController.text = profile.age.toString();
        _heightController.text = profile.height.toString();
        _weightController.text = profile.weight.toString();
      });
    }
  }

  void _saveProfile() async {
    if (_gender == null ||
        _nameController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _heightController.text.isEmpty ||
        _weightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('모든 항목을 입력해주세요.')),
      );
      return;
    }

    final age = int.tryParse(_ageController.text);
    final height = double.tryParse(_heightController.text);
    final weight = double.tryParse(_weightController.text);

    if (age == null || height == null || weight == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('숫자 항목에 올바른 값을 입력해주세요.')),
      );
      return;
    }

    final profile = UserProfile(
      gender: _gender!,
      name: _nameController.text,
      age: age,
      height: height,
      weight: weight,
    );

    await LocalStorageService.saveUserProfile(profile);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => CalendarScreen()),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('프로필 설정'), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('성별을 선택하세요', style: TextStyle(fontSize: 18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio<String>(
                  value: 'male',
                  groupValue: _gender,
                  onChanged: (value) => setState(() => _gender = value),
                ),
                Text('남자'),
                Radio<String>(
                  value: 'female',
                  groupValue: _gender,
                  onChanged: (value) => setState(() => _gender = value),
                ),
                Text('여자'),
              ],
            ),
            TextField(controller: _nameController, decoration: InputDecoration(labelText: '이름')),
            TextField(controller: _ageController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: '나이')),
            TextField(controller: _heightController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: '키 (cm)')),
            TextField(controller: _weightController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: '몸무게 (kg)')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _saveProfile, child: Text('등록하기')),
          ],
        ),
      ),
    );
  }
}