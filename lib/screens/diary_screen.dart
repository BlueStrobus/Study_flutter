import 'package:flutter/material.dart';

/// 1. 일기 목록 화면
class DiaryListScreen extends StatelessWidget {
  const DiaryListScreen({Key? key}) : super(key: key);

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
        title: const Text('ઇଓ FLY 다이어리'),
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
                '일기 등록한 날짜 표시',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '일기 미리보기',
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
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('일기 제목 $index'),
                      subtitle: const Text('일기 내용 미리보기...'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DiaryDetailScreen(diaryId: index),
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
              builder: (context) => const WriteDiaryScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// 2. 일기 작성 화면
class WriteDiaryScreen extends StatelessWidget {
  const WriteDiaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('일기 작성'),
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
                // 저장 로직
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

/// 3. 일기 상세 보기 화면
class DiaryDetailScreen extends StatelessWidget {
  final int diaryId;

  const DiaryDetailScreen({Key? key, required this.diaryId}) : super(key: key);

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
              '일기 제목 $diaryId',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 32, thickness: 1),
            const Text(
              '여기에 일기 내용이 표시됩니다. 이 텍스트는 예시 텍스트입니다.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
