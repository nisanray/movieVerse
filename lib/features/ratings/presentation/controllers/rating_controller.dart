import 'package:get/get.dart';
import '../../domain/entities/rating_entity.dart';
import '../../domain/repositories/rating_repository.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../../core/utils/snackbar_utils.dart';

class RatingController extends GetxController {
  final RatingRepository _repository;
  final int mediaId;
  final String mediaType;
  final AuthController _authController = Get.find<AuthController>();

  RatingController(this._repository, this.mediaId, this.mediaType);

  final RxDouble currentRating = 0.0.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserRating();
  }

  Future<void> _loadUserRating() async {
    final user = _authController.user.value;
    if (user == null) return;

    try {
      isLoading.value = true;
      final rating = await _repository.getUserRating(user.uid, mediaId);
      if (rating != null) {
        currentRating.value = rating.rating;
      }
    } catch (e) {
      // Silently fail for loads
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitRating({
    required double rating,
    required List<int> genreIds,
    String? title,
    String? posterPath,
  }) async {
    final user = _authController.user.value;
    if (user == null) {
      SnackbarUtils.info(
        title: 'Sign In Required',
        message: 'Please sign in to rate this content.',
      );
      return;
    }

    try {
      isLoading.value = true;
      final ratingEntity = RatingEntity(
        uid: user.uid,
        mediaId: mediaId,
        mediaType: mediaType,
        rating: rating,
        genreIds: genreIds,
        title: title,
        posterPath: posterPath,
        updatedAt: DateTime.now(),
      );

      await _repository.saveRating(ratingEntity);
      currentRating.value = rating;
      
      SnackbarUtils.success(
        title: 'Rating Saved',
        message: 'Thank you for your feedback!',
      );
    } catch (e) {
      SnackbarUtils.error(
        title: 'Error',
        message: 'Failed to save rating. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
