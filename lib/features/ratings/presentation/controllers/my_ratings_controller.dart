import 'package:get/get.dart';
import '../../domain/repositories/rating_repository.dart';
import '../../domain/entities/rating_entity.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../media_discovery/domain/entities/media.dart';

class MyRatingsController extends GetxController {
  final RatingRepository _repository;
  final AuthController _authController = Get.find<AuthController>();

  MyRatingsController(this._repository);

  final RxList<RatingEntity> userRatings = <RatingEntity>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRatings();
  }

  Future<void> fetchRatings() async {
    final user = _authController.user.value;
    if (user == null) return;

    try {
      isLoading.value = true;
      final ratings = await _repository.getAllUserRatings(user.uid);
      userRatings.assignAll(ratings);
    } catch (e) {
      // Error handling
    } finally {
      isLoading.value = false;
    }
  }

  /// Converts a RatingEntity to a Media object for the MediaCard widget.
  /// Handles missing metadata gracefully for old records.
  Media mapToMedia(RatingEntity rating) {
    return Media(
      id: rating.mediaId,
      title: rating.title ?? 'Unknown Title',
      overview: 'Your personal rating: ${rating.rating} stars',
      posterPath: rating.posterPath ?? '',
      backdropPath: '', // Not needed for library view
      voteAverage: rating.rating, // Show personal rating instead of TMDB
      releaseDate: '', 
      isMovie: rating.mediaType == 'movie',
      genreIds: rating.genreIds,
    );
  }
}
