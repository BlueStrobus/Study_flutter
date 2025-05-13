import 'package:flutter/material.dart';

class Page1 extends StatefulWidget {
  @override
  _page1State createState() => _page1State();
}

class _page1State extends State<Page1> {
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
        title: Text('화면1'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                '화면1',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.red,
                    child: Center(child: Text('1')),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.green,
                    child: Center(child: Text('2')),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.blue,
                    child: Center(child: Text('3')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
