# 📔 Flutter Diary App

Flutter로 개발한 통합 다이어리 애플리케이션입니다.  
일기 작성, 일정 관리, 날씨 조회, 할 일 목록 등 다양한 기능을 한 곳에서 제공합니다.

![platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS-blue)
![language](https://img.shields.io/badge/language-Dart-yellow)
![framework](https://img.shields.io/badge/framework-Flutter%203.x-blueviolet)

---

## 🧩 주요 기능

| 기능        | 설명                                                                 |
|-------------|----------------------------------------------------------------------|
| 📖 일기     | 제목, 내용, 날짜 기반 일기 작성 및 저장, 검색, 정렬                 |
| 📅 일정     | 달력 기반 일정 등록, 이모지, 시간, 연속일 관리, 알림 기능 포함       |
| 🌤 날씨     | 지역 기반 주간/시간별 날씨 조회 (OpenWeatherMap API 사용)           |
| ✅ 할 일     | 날짜별 할 일 작성, 완료/삭제, 체크 상태 저장                         |

---

## 📌 개발 목표

> 사용자에게 직관적인 UI로 일기, 일정, 날씨, 할 일을 통합 제공하는 생산성 앱 구현

- 지속 사용을 유도하는 UX 설계
- 로컬 저장소 기반 간단한 데이터 관리
- 기능별로 확장 가능한 구조 설계

---

## ⚙️ 기술 스택

- **Flutter 3.x / Dart**
- **로컬 저장소**: SharedPreferences → 추후 Hive 또는 Sqflite로 전환 예정
- **상태관리**: Provider (또는 Riverpod)
- **날씨 API**: [OpenWeatherMap API](https://openweathermap.org/api)
- **기타 패키지**
  - [`table_calendar`](https://pub.dev/packages/table_calendar)
  - [`flutter_local_notifications`](https://pub.dev/packages/flutter_local_notifications)
  - [`intl`](https://pub.dev/packages/intl)
  - [`shared_preferences`](https://pub.dev/packages/shared_preferences)

---

## 📂 폴더 구조

```bash
lib/
├── models/            # Diary, Schedule, Todo, Weather 모델
├── screens/           # 각 기능별 화면 (diary_screen.dart 등)
├── widgets/           # 공통 위젯 구성
├── services/          # API, 로컬 DB 처리
├── providers/         # 상태 관리
└── main.dart

