import 'package:hive/hive.dart';

class TutorialStorageService {
  static const String _boxName = 'tutorial_storage';
  static const String _hasSeenTutorialKey = 'has_seen_tutorial';
  static const String _currentPageKey = 'current_page';

  late Box _box;

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  Future<void> setTutorialCompleted() async {
    await _box.put(_hasSeenTutorialKey, true);
  }

  bool hasSeenTutorial() {
    return _box.get(_hasSeenTutorialKey, defaultValue: false);
  }

  Future<void> setCurrentPage(int page) async {
    await _box.put(_currentPageKey, page);
  }

  int getCurrentPage() {
    return _box.get(_currentPageKey, defaultValue: 0);
  }

  Future<void> clearTutorialData() async {
    await _box.clear();
  }
}