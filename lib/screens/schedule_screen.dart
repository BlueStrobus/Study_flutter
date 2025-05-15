import 'package:flutter/material.dart';

// 전역에 선언된 스케줄 리스트 (임시 저장소)
List<Map<String, dynamic>> schedule_item = [
  {'id': 1, 'title': '오늘스케줄1', 'content': '이모지랑 줄바꿈, 그림 중간에 넣는 방법을 찾아야하는데데'},
  {'id': 2, 'title': '오늘스케줄2', 'content': '내용내용내용 스케줄 내용용'},
  {'id': 3, 'title': '오늘스케줄3', 'content': '내용내용내용 스케줄 내용용'}
];

/// 1. 스케줄 목록 화면
class ScheduleListScreen extends StatelessWidget {
  const ScheduleListScreen({Key? key}) : super(key: key);

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
        title: const Text('ઇଓ FLY 스케줄'),
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
            // 스케줄 등록 날짜 표시 영역 (예시용 컨테이너)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue,
                  width: 2,
                ),
              ),
              child: const Text(
                '스케줄 등록한 날짜 표시',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 16),
            // 스케줄 미리보기 타이틀
            const Text(
              '스케줄 미리보기',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 8),
            // 스케줄 리스트 출력 영역
            // 스케줄 리스트 출력 영역
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
                child: ListView.builder(
                  itemCount: schedule_item.length,
                  itemBuilder: (context, index) {
                    final schedule = schedule_item[index];
                    return ListTile(
                      title: Text(schedule['title']), // 저장된 제목 사용
                      subtitle: Text(
                        (() {
                          final lines = schedule['content']
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
                            builder: (context) => ScheduleDetailScreen(
                                schedule: schedule), // schedule 자체 전달
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
      // 스케줄 작성 화면으로 이동하는 플로팅 버튼
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const WriteScheduleScreen(),
            ),
          );

          if (result == true) {
            // 새 스케줄가 추가되었음을 감지하고 화면 갱신
            (context as Element).markNeedsBuild(); // 또는 상태관리 적용
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// 2. 스케줄 작성 화면 (입력받고 저장 시 콘솔에 출력)
class WriteScheduleScreen extends StatefulWidget {
  const WriteScheduleScreen({Key? key}) : super(key: key);

  @override
  State<WriteScheduleScreen> createState() => _WriteScheduleScreenState();
}

class _WriteScheduleScreenState extends State<WriteScheduleScreen> {
  // 제목과 내용을 입력받기 위한 TextEditingController
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  // 저장 버튼 클릭 시 호출되는 함수
  void _saveSchedule() {
    final title = titleController.text;
    final content = contentController.text;

    // 아이디 부여: 리스트가 비어있으면 0, 아니면 마지막 id + 1
    final int id = schedule_item.isEmpty ? 0 : schedule_item.last['id'] + 1;

    // 리스트에 추가
    schedule_item.add({'id': id, 'title': title, 'content': content});

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
        title: const Text('스케줄 작성'),
        centerTitle: true,
      ),
      // 본문 입력 폼
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /** 작성 항목
             * 일정 이름
             * 대표 이모티콘( 기본값: 🪽 )
             * 시간 + 일정기한+ 반복여부
             * 알림 여부 + 알림 시간 + 반복여부
             * 일정 상세 내용
             */
            // 일정 이름 입력 필드
            TextField(
              controller: titleController, // 일정 이름 컨트롤러 연결
              decoration: const InputDecoration(
                labelText: '일정 이름',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 5),

            // 대표 이모티콘 입력 필드
            TextField(
              controller: titleController, // 대표 이모티콘 컨트롤러 연결
              decoration: const InputDecoration(
                labelText: '대표 이모티콘',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 5),

            // 일정 시간 + 일정기한+ 반복여부 입력 필드
            TextField(
              controller: titleController, // 일정 시간 + 일정기한+ 반복여부 컨트롤러 연결
              decoration: const InputDecoration(
                labelText: '일정 시간 + 일정기한+ 반복여부',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 5),

            // 알림 여부 + 알림 시간 + 반복여부 입력 필드
            TextField(
              controller: titleController, // 알림 여부 + 알림 시간 + 반복여부 컨트롤러 연결
              decoration: const InputDecoration(
                labelText: '알림 여부 + 알림 시간 + 반복여부',
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
              onPressed: _saveSchedule,
              child: const Text('저장'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 3. 스케줄 상세 보기 화면 (선택한 스케줄의 제목과 내용 표시)

class ScheduleDetailScreen extends StatelessWidget {
  final Map<String, dynamic> schedule;

  const ScheduleDetailScreen({Key? key, required this.schedule})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('스케줄 상세 보기'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              schedule['title'], // 실제 제목 표시
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 32, thickness: 1),
            Text(
              schedule['content'], // 실제 내용 표시
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
