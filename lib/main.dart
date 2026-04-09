import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/api/api_client.dart';
import 'core/bindings/initial_binding.dart';
import 'core/navigation/app_pages.dart';
import 'core/navigation/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'core/utils/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");
  
  // Initialize Core Services
  await Get.putAsync(() => StorageService().init());
  await Get.putAsync(() => ApiClient().init());
  
  runApp(const MovieVerseApp());
}

class MovieVerseApp extends StatelessWidget {
  const MovieVerseApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storageService = Get.find<StorageService>();
    final initialRoute = storageService.isOnboardingCompleted() 
        ? AppRoutes.home 
        : AppRoutes.onboarding;

    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialBinding: InitialBinding(),
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
    );
  }
}
