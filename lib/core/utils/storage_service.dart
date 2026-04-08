import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StorageService extends GetxService {
  late Box _appBox;
  static const String boxName = 'movie_verse_storage';
  static const String onboardingKey = 'onboarding_completed';

  Future<StorageService> init() async {
    await Hive.initFlutter();
    _appBox = await Hive.openBox(boxName);
    return this;
  }

  bool isOnboardingCompleted() {
    return _appBox.get(onboardingKey, defaultValue: false);
  }

  Future<void> setOnboardingCompleted(bool value) async {
    await _appBox.put(onboardingKey, value);
  }
}
