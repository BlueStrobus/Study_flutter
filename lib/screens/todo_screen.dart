import 'package:flutter/material.dart';

/// 1. 할 일 목록 화면
class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.pushNamed(context, '/home'),
          ),
        ),
        title: const Text('TODO 화면'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '달력',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue,
                  width: 2,
                ),
              ),
              child: const Text(
                'TODO 작성 날짜 표시',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'TODO 미리보기',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
                child: ListView.builder(
                  itemCount: 10, // 예시용 TODO 항목 10개
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('할 일 제목 $index'),
                      subtitle: const Text('할 일 내용 미리보기...'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TodoDetailScreen(todoId: index),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TodoWriteScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TodoWriteScreen extends StatelessWidget {
  const TodoWriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('할 일 작성'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: '제목',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: '내용',
                border: OutlineInputBorder(),
              ),
              maxLines: 10,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // 저장 로직 추가 예정
                Navigator.pop(context);
              },
              child: const Text('저장'),
            ),
          ],
        ),
      ),
    );
  }
}

class TodoDetailScreen extends StatelessWidget {
  final int todoId;

  const TodoDetailScreen({Key? key, required this.todoId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('할 일 상세 보기'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '할 일 제목 $todoId',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 32, thickness: 1),
            const Text(
              '여기에 할 일 내용이 표시됩니다. 이 텍스트는 예시입니다.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
