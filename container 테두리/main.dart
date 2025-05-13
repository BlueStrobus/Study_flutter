import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart'; // 점선 테두리 패키지 : 의존성 dotted_border: ^2.0.0

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text("고급 테두리 예시")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ✅ 1. 점선 테두리
            DottedBorder(
              color: Colors.blue,
              strokeWidth: 2,
              dashPattern: [6, 3], // 6px 그려지고 3px 비워짐
              borderType: BorderType.RRect,
              radius: Radius.circular(12),
              child: Container(
                height: 60,
                alignment: Alignment.center,
                child: Text('점선 테두리'),
              ),
            ),

            SizedBox(height: 20),

            // ✅ 2. 그림자 효과
            Container(
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: Offset(4, 4),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Text('그림자 있는 테두리'),
            ),

            SizedBox(height: 20),

            // ✅ 3. 원형 테두리
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.pink, width: 3),
                color: Colors.pink[50],
              ),
              child: Center(child: Text("원형")),
            ),

            SizedBox(height: 20),

            // ✅ 4. 라운드 + 그림자
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.3),
                    offset: Offset(0, 4),
                    blurRadius: 8,
                  )
                ],
              ),
              child: Text("라운드 + 그림자 효과"),
            ),

            SizedBox(height: 20),

            // ✅ 5. 반투명 테두리
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Text("반투명 테두리"),
            ),
          ],
        ),
      ),
    ),
  ));
}
