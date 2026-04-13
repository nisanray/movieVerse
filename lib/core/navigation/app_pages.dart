import 'package:get/get.dart';
import '../../features/movie_details/presentation/bindings/movie_details_binding.dart';
import '../../features/movie_details/presentation/pages/movie_details_page.dart';
import '../../features/movie_discovery/presentation/bindings/movie_discovery_binding.dart';
import '../../features/movie_discovery/presentation/pages/movie_discovery_page.dart';
import '../../features/onboarding/presentation/bindings/onboarding_binding.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/bindings/auth_binding.dart';
import '../../features/auth/presentation/pages/auth_page.dart';
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
      binding: MovieDiscoveryBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.movieDetails,
      page: () => const MovieDetailsPage(),
      binding: MovieDetailsBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.auth,
      page: () => const AuthPage(),
      binding: AuthBinding(),
      transition: Transition.downToUp,
    ),
  ];
}
