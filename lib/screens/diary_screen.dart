import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
// import 'package:fly_diary_0_0_0/widgets/calendar_widget.dart';

// 전역에 선언된 일기 리스트 (임시 저장소)
List<Map<String, dynamic>> diary_item = [
  {'id': 1, 'title': '오늘일기1', 'content': '이모지랑 줄바꿈, 그림 중간에 넣는 방법을 찾아야하는데데'},
  {'id': 2, 'title': '오늘일기2', 'content': '내용내용내용 일기 내용용'},
  {'id': 3, 'title': '오늘일기3', 'content': '내용내용내용 일기 내용용'}
];

/// 1. 일기 목록 화면
class DiaryListScreen extends StatelessWidget {
  const DiaryListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 상단 앱바 구성
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
            icon: const Icon(Icons.home),
            // 홈 아이콘 클릭 시 홈 화면으로 이동
            onPressed: () => Navigator.pushNamed(context, '/home'),
          ),
        ),
        title: const Text('ઇଓ FLY 다이어리'),
        centerTitle: true,
        elevation: 0,
      ),
      // 본문 영역 구성
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 달력 타이틀
            const Text(
              '달력',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 8),
            // 일기 등록 날짜 표시 영역 (예시용 컨테이너)
            const CalendarWidget(), // CalendarWidget 사용
            const SizedBox(height: 16),
            // 일기 미리보기 타이틀
            const Text(
              '일기 미리보기',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 8),
            // 일기 리스트 출력 영역
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
                child: ListView.builder(
                  itemCount: diary_item.length,
                  itemBuilder: (context, index) {
                    final diary = diary_item[index];
                    return ListTile(
                      title: Text(diary['title']), // 저장된 제목 사용
                      subtitle: Text(
                        (() {
                          final lines = diary['content']
                              .toString()
                              .split('\n'); // 줄바꿈 단위로 자른 배열
                          final firstLine = lines.first; // 첫째줄
                          return firstLine.length > 30
                              ? '${firstLine.substring(0, 30)}...'
                              : firstLine;
                        })(),
                      ),
                      // 내용 일부만 미리보기  첫줄 or 앞에 30자만
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DiaryDetailScreen(diary: diary), // diary 자체 전달
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      // 일기 작성 화면으로 이동하는 플로팅 버튼
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const WriteDiaryScreen(),
            ),
          );

          if (result == true) {
            // 새 일기가 추가되었음을 감지하고 화면 갱신
            (context as Element).markNeedsBuild(); // 또는 상태관리 적용
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// 2. 일기 작성 화면 (입력받고 저장 시 콘솔에 출력)
class WriteDiaryScreen extends StatefulWidget {
  const WriteDiaryScreen({Key? key}) : super(key: key);

  @override
  State<WriteDiaryScreen> createState() => _WriteDiaryScreenState();
}

class _WriteDiaryScreenState extends State<WriteDiaryScreen> {
  // 제목과 내용을 입력받기 위한 TextEditingController
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  // 저장 버튼 클릭 시 호출되는 함수
  void _saveDiary() {
    final title = titleController.text;
    final content = contentController.text;

    // 아이디 부여: 리스트가 비어있으면 0, 아니면 마지막 id + 1
    final int id = diary_item.isEmpty ? 0 : diary_item.last['id'] + 1;

    // 리스트에 추가
    diary_item.add({'id': id, 'title': title, 'content': content});

    print('제목: $title');
    print('내용: $content');

    // 작성 화면 종료
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 상단 앱바
      appBar: AppBar(
        title: const Text('일기 작성'),
        centerTitle: true,
      ),
      // 본문 입력 폼
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /** 작성 항목
             * 제목
             * 잠금 여부
             * 대표 이모지, 날씨 이모지 (기본값:🪽, 현재 날씨)
             * 기록일자 ( 클릭하면 달력 띄우기, 기본값 오늘 )
             * 배경 이미지 ( 이미지3개 이상 중에 선택)
             * 내용 ( 중간에 이미지, 링크, 줄띄우기, 폰트 변경, 글자크기, 굵게쓰기, 기울이기, 밑줄, 취소선 가능하게)
             */

            // 제목 입력 필드
            TextField(
              controller: titleController, // 제목 컨트롤러 연결
              decoration: const InputDecoration(
                labelText: '제목',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 5),

            // 잠금 설정 필드
            TextField(
              controller: titleController, // 잠금 설정 컨트롤러 연결
              decoration: const InputDecoration(
                labelText: '잠금 설정, 비밀번호 설정',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 5),

            // 대표 이모지, 날씨 이모지 (기본값:🪽, 현재 날씨)
            TextField(
              controller: titleController, // 제목 컨트롤러 연결
              decoration: const InputDecoration(
                labelText: '대표 이모지, 날씨 이모지',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 5),

            // 기록일자 입력 필드
            TextField(
              controller: titleController, // 기록일자 컨트롤러 연결
              decoration: const InputDecoration(
                labelText: '기록일자',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 5),

            // 배경 선택 필드
            TextField(
              controller: titleController, // 배경 컨트롤러 연결
              decoration: const InputDecoration(
                labelText: '배경',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 5),

            // 내용 입력 필드
            TextField(
              controller: contentController, // 내용 컨트롤러 연결
              decoration: const InputDecoration(
                labelText: '내용',
                border: OutlineInputBorder(),
              ),
              maxLines: 10, // 여러 줄 입력 가능
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: _saveDiary,
              child: const Text('저장'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 3. 일기 상세 보기 화면 (선택한 일기의 제목과 내용 표시)

class DiaryDetailScreen extends StatelessWidget {
  final Map<String, dynamic> diary;

  const DiaryDetailScreen({Key? key, required this.diary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('일기 상세 보기'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              diary['title'], // 실제 제목 표시
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 32, thickness: 1),
            Text(
              diary['content'], // 실제 내용 표시
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// diary_calendar 위젯 (controller는 GetX 예시)
class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: 'ko_KR',
      firstDay: DateTime.utc(2025, 1, 1),
      lastDay: DateTime.utc(2025, 12, 31),
      focusedDay: DateTime.now(), // 오늘 날짜를 중심으로 보여줌
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      calendarStyle: const CalendarStyle(
        isTodayHighlighted: true,
        selectedDecoration: BoxDecoration(
          color: Colors.transparent,
        ),
      ),
      selectedDayPredicate: (_) => false, // 선택 안 함
      onDaySelected: null, // 클릭 기능 없음
      calendarFormat: CalendarFormat.month,
    );
  }
}
