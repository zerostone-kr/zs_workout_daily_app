// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:zs_workout_daily_app/main.dart'; // ✅ 앱 시작 클래스 import

void main() {
  testWidgets('App launches and shows calendar title', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp()); // ✅ 클래스명 수정
    expect(find.text('운동 일기'), findsOneWidget);
  });
}
