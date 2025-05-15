import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart'; // 홈화면
import 'screens/diary_screen.dart'; // 다이어리 화면
import 'screens/schedule_screen.dart'; // 일정 화면
import 'screens/todo_screen.dart'; // 할일 화면
import 'screens/settings_screen.dart'; // 설정 화면
import 'package:intl/date_symbol_data_local.dart'; // 지역 설정

void main() async {
  await dotenv.load(); // 추가된 dotenv 패키지로 환경변수 로드
  WidgetsFlutterBinding.ensureInitialized(); // 필수!
  await initializeDateFormatting('ko_KR', null); // ← 여기서 날짜 포맷 초기화

  runApp(
    // provuder 추가
    ChangeNotifierProvider(
      create: (context) => SettingsProvider(),
      child: const DiaryApp(),
    ),
  );
}

// 다이어리 앱의 메인 위젯
// StatelessWidget은 상태를 가지지 않는 위젯으로, 앱의 UI를 정의하는 데 사용
// 코드 변경 시 새로고침 대신 핫 리로드를 사용하여 앱을 빠르게 업데이트할 수 있음
class DiaryApp extends StatelessWidget {
  const DiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fly Diary App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: const HomeScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/diary': (context) => DiaryListScreen(),
        '/write_diary': (context) => WriteDiaryScreen(),
        '/todo': (context) => TodoListScreen(),
        '/write_todo': (context) => WriteTodoScreen(),
        '/schedule': (context) => ScheduleListScreen(),
        '/write_ schedule': (context) => WriteScheduleScreen(),
        '/settings': (context) => SettingsScreen(),
      },
      initialRoute: '/home',
      debugShowCheckedModeBanner: false,
    );
  }
}
