import 'package:flutter/material.dart';

// 전역에 선언된 할일 리스트 (임시 저장소)
List<Map<String, dynamic>> todo_item = [
  {'id': 1, 'title': '오늘할일1', 'content': '이모지랑 줄바꿈, 그림 중간에 넣는 방법을 찾아야하는데데'},
  {'id': 2, 'title': '오늘할일2', 'content': '내용내용내용 할일 내용용'},
  {'id': 3, 'title': '오늘할일3', 'content': '내용내용내용 할일 내용용'}
];

/// 1. 할일 목록 화면
class TodoListScreen extends StatelessWidget {
  const TodoListScreen({Key? key}) : super(key: key);

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
        title: const Text('ઇଓ FLY 할일'),
        centerTitle: true,
        elevation: 0,
      ),
      // 본문 영역 구성
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 카테고리리 타이틀
            const Text(
              '달력',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 8),
            // 할일 등록 날짜 표시 영역 (예시용 컨테이너)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue,
                  width: 2,
                ),
              ),
              child: const Text(
                '카테고리 이모지랑 이름을 동글사각형 그레이드로 만들어서 2줄 가로 슬라이드 배열',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 16),
            // 할일 미리보기 타이틀
            const Text(
              '할일 미리보기',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 8),
            // 할일 리스트 출력 영역
            // 할일 리스트 출력 영역
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
                child: ListView.builder(
                  itemCount: todo_item.length,
                  itemBuilder: (context, index) {
                    final todo = todo_item[index];
                    return ListTile(
                      title: Text(todo['title']), // 저장된 제목 사용
                      subtitle: Text(
                        (() {
                          final lines = todo['content']
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
                                TodoDetailScreen(todo: todo), // todo 자체 전달
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
      // 할일 작성 화면으로 이동하는 플로팅 버튼
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const WriteTodoScreen(),
            ),
          );

          if (result == true) {
            // 새 할일가 추가되었음을 감지하고 화면 갱신
            (context as Element).markNeedsBuild(); // 또는 상태관리 적용
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// 1-1. 카테고리 목록 화면

/// 2. 할일 작성 화면 (입력받고 저장 시 콘솔에 출력)
class WriteTodoScreen extends StatefulWidget {
  const WriteTodoScreen({Key? key}) : super(key: key);

  @override
  State<WriteTodoScreen> createState() => _WriteTodoScreenState();
}

class _WriteTodoScreenState extends State<WriteTodoScreen> {
  // 제목과 내용을 입력받기 위한 TextEditingController
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  // 저장 버튼 클릭 시 호출되는 함수
  void _saveTodo() {
    final title = titleController.text;
    final content = contentController.text;

    // 아이디 부여: 리스트가 비어있으면 0, 아니면 마지막 id + 1
    final int id = todo_item.isEmpty ? 0 : todo_item.last['id'] + 1;

    // 리스트에 추가
    todo_item.add({'id': id, 'title': title, 'content': content});

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
        title: const Text('할일 작성'),
        centerTitle: true,
      ),
      // 본문 입력 폼
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /** 작성 항목
             * 할일 이름
             * 카테고리(드롭다운 선택) + 카테고리 추가  (카테고리는 알람 및 완료체크 리셋 관련해 반복여부 묻기 매일/매주/매달/매년)
             * 마감일 여부, 마감일시
             * 알림 여부 + 알림 시간
             * 일정 상세 내용
            */
            // 제목 입력 필드
            TextField(
              controller: titleController, // 제목 컨트롤러 연결
              decoration: const InputDecoration(
                labelText: '할일',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // 카테고리 입력 필드
            TextField(
              controller: titleController, // 카테고리 컨트롤러 연결
              decoration: const InputDecoration(
                labelText: '카테고리',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // 마감일 입력 필드
            TextField(
              controller: titleController, // 마감일 컨트롤러 연결
              decoration: const InputDecoration(
                labelText: '마감일',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // 알림 입력 필드
            TextField(
              controller: titleController, // 알림 컨트롤러 연결
              decoration: const InputDecoration(
                labelText: '알림',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // 내용 입력 필드
            TextField(
              controller: contentController, // 내용 컨트롤러 연결
              decoration: const InputDecoration(
                labelText: '내용',
                border: OutlineInputBorder(),
              ),
              maxLines: 10, // 여러 줄 입력 가능
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveTodo,
              child: const Text('저장'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 3. 할일 상세 보기 화면 (선택한 할일의 제목과 내용 표시)

class TodoDetailScreen extends StatelessWidget {
  final Map<String, dynamic> todo;

  const TodoDetailScreen({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('할일 상세 보기'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              todo['title'], // 실제 제목 표시
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 32, thickness: 1),
            Text(
              todo['content'], // 실제 내용 표시
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
