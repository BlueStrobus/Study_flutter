import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              // 앱 기본색상
              seedColor: const Color.fromARGB(160, 119, 214, 238)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  // ↓ 버튼을 상태에 연결하기. getNext 메서드를 추가.
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  /// ↓ favorites 속성 추가
  final List<WordPair> _favorites = [];
  // var favorites = <WordPair>[];

  void toggleFavorite() {
    if (_favorites.contains(current)) {
      _favorites.remove(current);
    } else {
      _favorites.add(current); // 즐겨찾기 단어 추가
    }
    notifyListeners();
  }

  ///
  void removeFavorite(WordPair pair) {
    _favorites.remove(pair);
    notifyListeners();
  }

  // ✅ 외부 접근용 getter 추가
  List<WordPair> get favorites => _favorites;
}

///
// MyHomePage 클래스는 앱의 메인 화면을 정의하는 StatelessWidget
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0; // 선택된 네비게이션 항목 인덱스 초기값(0 = Home)
  @override
  Widget build(BuildContext context) {
    /// 추가
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesList(); // Placeholder();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    ///

    // Scaffold: 앱의 기본 구조를 제공하는 위젯 (앱바, 바디, 네비게이션 등)
    return LayoutBuilder(// 여기 수정
        builder: (context, constraints) {
      // 여기 수정
      return Scaffold(
        body: Row(
          children: [
            // SafeArea: 화면의 노치나 상태바 영역을 피해서 콘텐츠를 표시
            SafeArea(
              child: NavigationRail(
                // extended: false, // 네비게이션 레일이 확장되지 않은 컴팩트 모드
                extended: constraints.maxWidth >= 600, // ← 600px 이상일 때 확장(true)
                // destinations: 네비게이션 항목 리스트
                destinations: [
                  // NavigationRailDestination: 네비게이션 항목 정의
                  NavigationRailDestination(
                    icon: Icon(Icons.home), // 홈 아이콘
                    label: Text('Home'), // 홈 라벨
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite), // 즐겨찾기 아이콘
                    label: Text('Favorites'), // 즐겨찾기 라벨
                  ),
                ],
                selectedIndex: selectedIndex, // ← Change to this.
                onDestinationSelected: (value) {
                  // onDestinationSelected: 네비게이션 항목 선택 시 호출되는 콜백
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            // Expanded: 남은 공간을 채우는 위젯
            Expanded(
              child: Container(
                // 컨테이너의 배경색을 테마의 primaryContainer 색상으로 설정
                color: Theme.of(context).colorScheme.primaryContainer,
                // GeneratorPage: 메인 콘텐츠를 표시하는 위젯
                child: page, // ← 코드 수정
                // child: GeneratorPage(),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// GeneratorPage 클래스는 메인 콘텐츠를 표시하는 StatelessWidget
class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // context.watch: MyAppState의 상태를 감시하여 변경 시 UI 갱신
    var appState = context.watch<MyAppState>();
    var pair = appState.current; // 현재 표시할 데이터 (예: 단어 쌍)

    // 아이콘 설정: 즐겨찾기 여부에 따라 아이콘 변경
    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite; // 즐겨찾기에 포함된 경우 채워진 하트
    } else {
      icon = Icons.favorite_border; // 포함되지 않은 경우 빈 하트
    }

    // Center: 자식 위젯을 화면 중앙에 배치
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // 세로축 중앙 정렬
        children: [
          // BigCard: pair 데이터를 표시하는 사용자 정의 위젯
          BigCard(pair: pair),
          SizedBox(height: 10), // 위젯 간 10px 간격
          // Row: 버튼들을 가로로 배치
          Row(
            mainAxisSize: MainAxisSize.min, // Row 크기를 자식 크기에 맞춤
            children: [
              // ElevatedButton.icon: 아이콘과 텍스트가 포함된 버튼
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite(); // 즐겨찾기 토글 함수 호출
                },
                icon: Icon(icon), // 동적 아이콘 표시
                label: Text('Like'), // 버튼 텍스트
              ),
              SizedBox(width: 10), // 버튼 간 10px 간격
              // ElevatedButton: 다음 항목으로 이동하는 버튼
              ElevatedButton(
                onPressed: () {
                  appState.getNext(); // 다음 데이터로 이동
                },
                child: Text('Next'), // 버튼 텍스트
              ),
            ],
          ),
        ],
      ),
    );
  }
}

///
class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // ↓ 코드 추가
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontWeight: FontWeight.bold,
      letterSpacing: 2,
    );

    return Card(
      color: theme.colorScheme.primary,
      elevation: 8, // ← 그림자 깊이
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // ← 둥근 모서리
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        //child: Text(pair.asLowerCase, style: style),
        // ↓ 코드 수정
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}

class FavoritesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<MyAppState>().favorites;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: SafeArea(
            child: Text(
              '즐겨찾기: ${favorites.length}개',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        //SizedBox(height: 5), // 20px 간격
        Expanded(
          child: favorites.isEmpty
              ? Center(child: Text('즐겨찾기한 단어가 없습니다.'))
              : ListView.builder(
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final pair = favorites[index];
                    return ListTile(
                      title: Text(pair.asPascalCase),
                      trailing: IconButton(
                        icon: Icon(Icons.favorite, color: Colors.red),
                        onPressed: () {
                          context.read<MyAppState>().removeFavorite(pair);
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
