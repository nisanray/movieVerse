import 'package:get/get.dart';
import '../../features/media_details/presentation/bindings/media_details_binding.dart';
import '../../features/media_details/presentation/pages/media_details_page.dart';
import '../../features/onboarding/presentation/bindings/onboarding_binding.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/bindings/auth_binding.dart';
import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/profile/presentation/bindings/profile_binding.dart';
import '../../features/profile/presentation/pages/profile_management_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/library/presentation/pages/my_library_page.dart';
import '../../features/library/presentation/bindings/library_binding.dart';
import '../../features/main/presentation/bindings/main_binding.dart';
import '../../features/main/presentation/pages/main_page.dart';
import '../../features/splash/presentation/bindings/splash_binding.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.initial,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingPage(),
      binding: OnboardingBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const MainPage(),
      binding: MainBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.mediaDetails,
      page: () => const MediaDetailsPage(),
      binding: MediaDetailsBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.auth,
      page: () => const AuthPage(),
      binding: AuthBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfilePage(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.profileManagement,
      page: () => const ProfileManagementPage(),
      binding: ProfileBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.watchlist,
      page: () => const MyLibraryPage(),
      binding: LibraryBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.myRatings,
      page: () => const MyLibraryPage(),
      binding: LibraryBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
  ];
}
