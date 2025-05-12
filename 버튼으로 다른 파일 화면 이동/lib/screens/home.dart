import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('홈 화면'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // 콘텐츠를 중앙에 정렬
          children: [
            Text(
              '홈 화면',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20), // 텍스트와 버튼 사이 간격
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/page1'),
              child: Text('화면1'),
            ),
            SizedBox(height: 10), // 버튼 간 간격
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/page2'),
              child: Text('화면2'),
            ),
          ],
        ),
      ),
    );
  }
}
