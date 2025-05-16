import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart' show DateFormat;

// 더미데이터
// 전역에 선언된 일기 리스트 (임시 저장소)
List<Map<String, dynamic>> diary_item = [
  {'id': 1, 'title': '오늘일기1', 'content': '이모지랑 줄바꿈, 그림 중간에 넣는 방법을 찾아야하는데데'},
  {'id': 2, 'title': '오늘일기2', 'content': '내용내용내용 일기 내용용'},
  {'id': 3, 'title': '오늘일기3', 'content': '내용내용내용 일기 내용용'}
];

/// 1. 일기 목록 화면
class DiaryListScreen extends StatefulWidget {
  @override
  _DiaryListScreen createState() => _DiaryListScreen();
}

class _DiaryListScreen extends State<DiaryListScreen> {
  // 검색창
  final TextEditingController searchController = TextEditingController();

  // 더미 데이터
  /*
  final List<String> totalItems =
      List.generate(200, (index) => '일기 ${index + 1}');
      */
  static const int pageSize = 20;
  int currentPage = 1;

  List<Map<String, dynamic>> get currentItems {
    final start = (currentPage - 1) * pageSize;
    final end = (start + pageSize) > diary_item.length
        ? diary_item.length
        : start + pageSize;
    return diary_item.sublist(start, end);
  }

  int get totalPages => (diary_item.length / pageSize).ceil();

  List<int> getPageNumbers() {
    int startPage = currentPage - 2;
    int endPage = currentPage + 2;

    if (startPage < 1) {
      endPage += (1 - startPage);
      startPage = 1;
    }

    if (endPage > totalPages) {
      startPage -= (endPage - totalPages);
      endPage = totalPages;
    }

    if (startPage < 1) startPage = 1;

    List<int> pages = [];
    for (int i = startPage; i <= endPage; i++) {
      pages.add(i);
    }
    return pages;
  }

  void goToPage(int page) {
    if (page >= 1 && page <= totalPages) {
      setState(() {
        currentPage = page;
      });
    }
  }

  // 검색
  // final keyword = searchController.text.trim();
  // final results = diary_item
  //     .where((item) =>
  //         item['title'].toString().contains(keyword) ||
  //         item['content'].toString().contains(keyword))
  //     .toList();

  late ScrollController listScrollController;

  @override
  void initState() {
    super.initState();
    listScrollController = ScrollController();
  }

  @override
  void dispose() {
    listScrollController.dispose();
    super.dispose();
  }

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
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    // EdgeInsets.fromLTRB(left, top, right, bottom)
                    padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                    child: TableCalendar(
                      focusedDay: DateTime.now(),
                      firstDay: DateTime(2020, 1, 1),
                      lastDay: DateTime(2030, 12, 31),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        8, 10, 8, 0), // EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DropdownButton<String>(
                          value: '최신순',
                          items: ['최신순', '오래된순', '제목순']
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (val) {},
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextField(
                              controller: searchController,
                              decoration: const InputDecoration(
                                labelText: '검색 🔍',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // 검색 로직
                            print(searchController.text);
                          },
                          child: Icon(Icons.search),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        // 본문의 리스트와 페이징
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // 리스트 보여주는 부분 (스크롤 가능)
              Expanded(
                child: ListView.builder(
                  controller: listScrollController,
                  itemCount: currentItems.length,
                  itemBuilder: (context, index) {
                    /* return ListTile(
                      title: Text(currentItems[index]),
                    );*/
                    final diary = currentItems[index]; // 현재 보이는 목록
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
              //페이징 버튼
              Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 이전 페이지
                    IconButton(
                      icon: Icon(Icons.chevron_left),
                      onPressed: currentPage > 1
                          ? () => goToPage(currentPage - 1)
                          : null,
                    ),
                    // 페이지 번호 버튼들
                    ...getPageNumbers().map((page) => GestureDetector(
                          onTap: () => goToPage(page),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: page == currentPage
                                  ? Colors.blue
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '$page',
                              style: TextStyle(
                                color: page == currentPage
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        )),
                    // 다음 페이지
                    IconButton(
                      icon: Icon(Icons.chevron_right),
                      onPressed: currentPage < totalPages
                          ? () => goToPage(currentPage + 1)
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // 플로팅 추가 버튼
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
  // 제목창
  final TextEditingController titleController = TextEditingController();
  // 대표 이모지, 날씨 이모지 < 버튼으로
  String mainEmoji = '🪽';
  String weatherEmoji = '☀️'; // 일기예보 연결하고 현재날씨로 바꾸기
  // 잠금 여부 - pw + 토글
  bool isLocked = false;
  final TextEditingController pwController = TextEditingController();

  // 기록일자
  //final TextEditingController searchController = TextEditingController();
  late DateTime selectedDate = DateTime.now();

  // 배경
  final TextEditingController bgController = TextEditingController();

  // 내용
  final TextEditingController contentController = TextEditingController();

  // 저장 버튼 클릭 시 호출되는 함수
  void _saveDiary() {
    final title = titleController.text;
    final content = contentController.text;

    // 아이디 부여: 리스트가 비어있으면 0, 아니면 마지막 id + 1
    final int id = diary_item.isEmpty ? 0 : diary_item.last['id'] + 1;

    // 리스트에 추가
    diary_item.add({
      'id': id,
      'title': title,
      'content': content,
      'date': selectedDate,
      'emoji': mainEmoji,
      'weather': weatherEmoji,
      'isLocked': isLocked,
      'pw': pwController.text,
    });

    print('제목: $title');
    print('내용: $content');

    // 작성 화면 종료
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            // onPressed: () => Navigator.pop(context, true),
            onPressed: () => Navigator.pushNamed(context, '/diary'),
          ),
        ),
        title: const Text('ઇଓ 일기 작성'),
        centerTitle: true,
        elevation: 0,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Column(
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
                  // TextField(
                  //   controller: pwController, // 잠금 설정 컨트롤러 연결
                  //   decoration: const InputDecoration(
                  //     labelText: '잠금 설정, 비밀번호 설정',
                  //     border: OutlineInputBorder(),
                  //   ),
                  // ),
                  // const SizedBox(height: 5),
                  Row(
                    children: [
                      Text('대표 이모지'),
                      DropdownButton<String>(
                        value: mainEmoji,
                        items: ['🪽', '😊', '😴', '🔥']
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) => setState(() => mainEmoji = val!),
                      ),
                      Text('날씨'),
                      DropdownButton<String>(
                        value: weatherEmoji,
                        items: ['☀️', '🌧️', '⛅', '🌩️']
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) => setState(() => weatherEmoji = val!),
                      ),
                      Text('잠금 여부'),
                      Switch(
                        value: isLocked,
                        onChanged: (val) {
                          setState(() {
                            isLocked = val;
                          });
                        },
                      ),
                      if (isLocked)
                        Expanded(
                          child: TextField(
                            controller: pwController,
                            obscureText: true,
                            decoration: InputDecoration(labelText: '비밀번호'),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  /*   // 대표 이모지, 날씨 이모지 (기본값:🪽, 현재 날씨)
                  TextField(
                    controller: titleController, // 제목 컨트롤러 연결
                    decoration: const InputDecoration(
                      labelText: '대표 이모지, 날씨 이모지',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 5),*/

                  // 기록일자 입력 필드
                  /* TextField(
                    controller: titleController, // 기록일자 컨트롤러 연결
                    decoration: const InputDecoration(
                      labelText: '기록일자',
                      border: OutlineInputBorder(),
                    ),
                  ),*/
                  ListTile(
                    title: Text(
                        '기록일자: ${DateFormat('yyyy-MM-dd').format(selectedDate)}'),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() => selectedDate = picked);
                      }
                    },
                  ),

                  const SizedBox(height: 5),

                  // 배경 선택 필드
                  TextField(
                    controller: bgController,
                    decoration: InputDecoration(
                      labelText: '배경',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: contentController,
                    maxLines: 10,
                    decoration: const InputDecoration(
                      labelText: '내용',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: _saveDiary,
                    child: const Text('저장'),
                  ),
                ],
              ),
            ),
          ];
        },
        body: SizedBox.shrink(),
      ),
    );
  }
}

/// 3. 일기 상세 보기 화면 (선택한 일기의 제목과 내용 표시)

class DiaryDetailScreen extends StatelessWidget {
  final Map<String, dynamic> diary;

  const DiaryDetailScreen({Key? key, required this.diary}) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(diary['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(diary['content']),
      ),
    );
  }
}
