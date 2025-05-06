import 'package:flutter/material.dart';
import 'screens/profile_setup_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/exercise_screen.dart';
import 'screens/settings_screen.dart';
import 'services/local_storage_service.dart';
import 'models/user_profile.dart';
import 'widgets/bottom_nav_bar.dart';

/// 앱 진입점. WorkoutDiaryApp을 실행.
void main() {
  runApp(WorkoutDiaryApp());
}

/// 루트 애플리케이션 위젯. MaterialApp을 구성하고 InitialScreenSelector를 홈으로 설정함.
class WorkoutDiaryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('[WorkoutDiaryApp] build() called');
    return MaterialApp(
      title: '운동 일기 앱',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: InitialScreenSelector(),
    );
  }
}

/// 초기 화면 결정 위젯. 저장된 사용자 프로필 존재 여부에 따라
/// ProfileSetupScreen 또는 MainPage로 이동.
class InitialScreenSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile?>(
      future: LocalStorageService.loadUserProfile(),
      builder: (context, snapshot) {
        print('[InitialScreenSelector] connection state: ${snapshot.connectionState}');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else {
          if (snapshot.data == null) {
            print('[InitialScreenSelector] No profile found, showing ProfileSetupScreen');
            return ProfileSetupScreen();
          } else {
            print('[InitialScreenSelector] Profile found, showing MainPage');
            return MainPage();
          }
        }
      },
    );
  }
}

/// 하단 네비게이션 바를 포함하는 메인 화면.
/// Calendar, Exercise, Settings 탭을 포함.
class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    CalendarScreen(),
    ExerciseScreen(selectedDate: DateTime.now()), // ✅ 수정
    SettingsScreen(),
  ];

  /// 하단 네비게이션 항목을 탭했을 때 인덱스를 업데이트.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /// 현재 선택된 탭 인덱스를 기준으로 해당 화면을 표시.
  @override
  Widget build(BuildContext context) {
    print('[MainPage] build() called with index $_selectedIndex');
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
