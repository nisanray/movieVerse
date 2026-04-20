import 'dart:async';
import 'package:get/get.dart';
import '../../domain/repositories/rating_repository.dart';
import '../../domain/entities/rating_entity.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../../core/domain/entities/media.dart';
import '../../../media_discovery/domain/repositories/media_repository.dart';

class MyRatingsController extends GetxController {
  final RatingRepository _repository;
  final AuthController _authController = Get.find<AuthController>();
  final MediaRepository _mediaRepository = Get.find<MediaRepository>();

  MyRatingsController(this._repository);

  final RxList<RatingEntity> userRatings = <RatingEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxMap<int, Media> _mediaCache = <int, Media>{}.obs;
  StreamSubscription? _ratingsSubscription;

  @override
  void onInit() {
    super.onInit();
    ever(_authController.user, (_) => _listenToRatings());
    _listenToRatings();
  }

  void _listenToRatings() {
    _ratingsSubscription?.cancel();
    
    final user = _authController.user.value;
    if (user == null) {
      userRatings.clear();
      return;
    }

    isLoading.value = true;
    _ratingsSubscription = _repository.watchAllUserRatings(user.uid).listen(
      (ratings) async {
        userRatings.assignAll(ratings);
        isLoading.value = false;

        // Fetch missing media details for ratings without title/poster
        for (final rating in ratings) {
          if (rating.title == null || rating.posterPath == null) {
            await _fetchMissingMediaDetails(rating);
          }
        }
      },
      onError: (e) {
        isLoading.value = false;
      },
    );
  }

  @override
  void onClose() {
    _ratingsSubscription?.cancel();
    super.onClose();
  }

  Future<void> _fetchMissingMediaDetails(RatingEntity rating) async {
    if (_mediaCache.containsKey(rating.mediaId)) return;

    try {
      final media = await _mediaRepository.getMediaDetails(
        rating.mediaId,
        rating.mediaType,
      );
      if (media != null) {
        _mediaCache[rating.mediaId] = media;
      }
    } catch (e) {
      // If fetch fails, use fallback data
    }
  }

  /// Converts a RatingEntity to a Media object for the MediaCard widget.
  /// Handles missing metadata gracefully for old records.
  Media mapToMedia(RatingEntity rating) {
    // Check if we have cached media details
    if (_mediaCache.containsKey(rating.mediaId)) {
      final cachedMedia = _mediaCache[rating.mediaId]!;
      return Media(
        id: rating.mediaId,
        title: cachedMedia.title,
        overview: 'Your personal rating: ${rating.rating} stars',
        posterPath: cachedMedia.posterPath,
        backdropPath: '', // Not needed for library view
        voteAverage: rating.rating, // Show personal rating instead of TMDB
        releaseDate: cachedMedia.releaseDate,
        isMovie: rating.mediaType == 'movie',
        genreIds: rating.genreIds,
      );
    }

    // Fallback to stored data in RatingEntity
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

