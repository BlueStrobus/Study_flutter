import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';

// SettingsProvider 클래스 (메인 파일에 없다고 가정하고 추가)
class SettingsProvider with ChangeNotifier {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';
  File? _profileImage;

  bool get isDarkMode => _isDarkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  String get selectedLanguage => _selectedLanguage;
  File? get profileImage => _profileImage;

  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  void toggleNotifications(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
  }

  void setLanguage(String language) {
    _selectedLanguage = language;
    notifyListeners();
  }

  void setProfileImage(File? image) {
    _profileImage = image;
    notifyListeners();
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  Future<void> _pickImage(BuildContext context) async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      settings.setProfileImage(File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        // 왼쪽에 10px 여백과 홈 버튼 유지
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.pushNamed(context, '/home'),
          ),
        ),
        title: const Text('ઇଓ FLY 설정'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 프로필 사진 변경
          ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: settings.profileImage != null
                  ? FileImage(settings.profileImage!)
                  : null,
              child: settings.profileImage == null
                  ? const Icon(Icons.person, size: 30)
                  : null,
            ),
            title: const Text('프로필 사진 변경'),
            subtitle: const Text('갤러리에서 사진 선택'),
            onTap: () => _pickImage(context),
          ),
          const Divider(),
          // 다크 모드 토글
          SwitchListTile(
            title: const Text('다크 모드'),
            subtitle: const Text('다크 테마 활성화'),
            value: settings.isDarkMode,
            onChanged: (value) {
              settings.toggleDarkMode(value);
            },
          ),
          const Divider(),
          // 알림 설정 토글
          SwitchListTile(
            title: const Text('알림'),
            subtitle: const Text('푸시 알림 활성화'),
            value: settings.notificationsEnabled,
            onChanged: (value) {
              settings.toggleNotifications(value);
            },
          ),
          const Divider(),
          // 언어 선택
          ListTile(
            title: const Text('언어'),
            subtitle: Text(settings.selectedLanguage),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('언어 선택'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: ['English', '한국어', 'Español'].map((language) {
                        return ListTile(
                          title: Text(language),
                          onTap: () {
                            settings.setLanguage(language);
                            Navigator.pop(context);
                          },
                        );
                      }).toList(),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
