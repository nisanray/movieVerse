import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StorageService extends GetxService {
  late Box _appBox;
  late Box _aiHistoryBox;
  static const String boxName = 'movie_verse_storage';
  static const String aiBoxName = 'ai_scout_history';
  static const String onboardingKey = 'onboarding_completed';

  Future<StorageService> init() async {
    await Hive.initFlutter();
    _appBox = await Hive.openBox(boxName);
    _aiHistoryBox = await Hive.openBox(aiBoxName);
    return this;
  }

  Box get aiHistoryBox => _aiHistoryBox;

  bool isOnboardingCompleted() {
    return _appBox.get(onboardingKey, defaultValue: false);
  }

  Future<void> setOnboardingCompleted(bool value) async {
    await _appBox.put(onboardingKey, value);
  }
}
