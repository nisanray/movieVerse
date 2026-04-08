import 'package:get/get.dart';
import '../../features/movie_discovery/presentation/pages/movie_discovery_page.dart';
import '../../features/onboarding/presentation/bindings/onboarding_binding.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingPage(),
      binding: OnboardingBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const MovieDiscoveryPage(),
      // binding: MovieDiscoveryBinding(), // Add later
      transition: Transition.fadeIn,
    ),
    // Future routes will be added here
  ];
}
