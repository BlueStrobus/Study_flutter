import 'package:flutter/material.dart';

class Page2 extends StatefulWidget {
  @override
  _page2State createState() => _page2State();
}

class _page2State extends State<Page2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 왼쪽에 10px 여백과 홈 버튼 추가
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
            icon: Icon(Icons.home),
            onPressed: () => Navigator.pushNamed(context, '/home'),
          ),
        ),
        title: Text('화면2'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Text(
          '화면2',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
