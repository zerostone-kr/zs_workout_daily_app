import 'package:flutter/material.dart';
import 'screens/calendar_screen.dart';
import 'screens/exercise_screen.dart';
import 'screens/profile_setup_screen.dart';
import 'screens/settings_screen.dart';
import 'services/local_storage_service.dart';
import 'models/user_profile.dart';

void main() => runApp(MyApp());

/// 앱 전체를 감싸는 루트 위젯
/// 사용자 프로필 여부에 따라 초기 진입 화면을 결정합니다.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '운동일기',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: InitialScreenSelector(), // ✅ 초기 화면 결정 위젯
    );
  }
}

/// SharedPreferences에서 사용자 프로필이 있는지 확인 후
/// ProfileSetupScreen 또는 MainTabScreen을 띄워주는 위젯
class InitialScreenSelector extends StatelessWidget {
  Future<Widget> _getStartScreen() async {
    final UserProfile? profile = await LocalStorageService.loadUserProfile();

    // ✅ 콘솔 로그로 로딩 여부 출력
    if (profile != null) {
      print('[main] 사용자 프로필 로딩됨: ${profile.name}, BMI: ${profile.bmi.toStringAsFixed(1)}');
    } else {
      print('[main] 사용자 프로필 없음 → 설정화면 이동');
    }

    return profile == null ? ProfileSetupScreen() : MainTabScreen();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _getStartScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return snapshot.data!;
        } else {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}

/// 하단 네비게이션 탭을 구성하는 메인 화면 위젯
class MainTabScreen extends StatefulWidget {
  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _selectedIndex = 0;

  /// 각 탭에 연결될 화면 리스트
  final List<Widget> _screens = [
    CalendarScreen(),                                  // 🗓 달력
    ExerciseScreen(selectedDate: DateTime.now()),      // 🏋 운동 (오늘 날짜 기본값)
    SettingsScreen(),                                  // ⚙ 설정
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // ✅ 선택된 탭의 화면 출력
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index), // ✅ 탭 전환 처리
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: '달력'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: '운동'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
        ],
      ),
    );
  }
}
