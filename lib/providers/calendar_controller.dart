//import 'package:flutter/material.dart';

class CalendarController {
  DateTime focusedDay = DateTime.now(); //포커스 위치 - 오늘
  DateTime selectedDay = DateTime.now(); // 선택위치 - 오늘
  DateTime firstDay = DateTime(2025, 1, 1);
  //DateTime.now().subtract(const Duration(days: 365 * 10)); //달력의 최초 일자 ( 젤 앞으로 어디까지 넘길 수 있는가 )
  DateTime lastDay = DateTime.now().add(
      const Duration(days: 365 * 10)); //달력의 마지막 일자 ( 젤 마지막으로 어디까지 넘길 수 있는가 )

  void dispose() {
    // 필요한 경우 리소스 해제
  }
}
