import 'package:flutter/material.dart';
import 'home.dart'; // 홈화면
import '1p.dart';
import '2p.dart';

void main() async {
  runApp(const MyApp());
}

// 다이어리 앱의 메인 위젯
// StatelessWidget은 상태를 가지지 않는 위젯으로, 앱의 UI를 정의하는 데 사용
// 코드 변경 시 새로고침 대신 핫 리로드를 사용하여 앱을 빠르게 업데이트할 수 있음
class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        '/home': (context) => Home(),
        '/page1': (context) => Page1(),
        '/page2': (context) => Page2(),
      },
      initialRoute: '/home',
      debugShowCheckedModeBanner: false,
    );
  }
}
