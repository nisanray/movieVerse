import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../domain/entities/movie_details_entities.dart';
import '../../domain/repositories/movie_details_repository.dart';

/// [MovieDetailsController] manages the state for the Movie Details screen.
/// It handles complex data fetching (Details, Cast, Videos) and the YouTube player lifecycle.
class MovieDetailsController extends GetxController with StateMixin<MovieDetails> {
  final MovieDetailsRepository _repository;
  final int movieId;

  MovieDetailsController(this._repository, this.movieId);

  /// Controller for the YouTube player to play movie trailers.
  YoutubePlayerController? youtubeController;
  
  /// Observable to notify the UI when the trailer is ready to be played.
  final RxBool isTrailerReady = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Load movie details immediately on route transition.
    fetchMovieDetails();
  }

  /// Fetches the complete movie details, credits, and video trailers.
  Future<void> fetchMovieDetails() async {
    try {
      change(null, status: RxStatus.loading());
      final result = await _repository.getMovieDetails(movieId);
      
      // Attempt to initialize the YouTube player if movie trailers are found.
      if (result.videos.isNotEmpty) {
        // Safe-cast to List<Video> to avoid subtype mismatch errors in the firstWhere orElse closure.
        final List<Video> videos = result.videos.cast<Video>();
        
        // Prioritize official 'Trailer' types from 'YouTube'.
        final trailer = videos.firstWhere(
          (v) => v.type == 'Trailer' && v.site == 'YouTube',
          orElse: () => videos.first,
        );
        
        // Initialize the player settings (Autoplay is off to respect user bandwidth).
        youtubeController = YoutubePlayerController(
          initialVideoId: trailer.key,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
          ),
        );
        isTrailerReady.value = true;
      }
      
      change(result, status: RxStatus.success());
    } catch (e) {
      // Handle scenario-specific errors and update the UI state.
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  @override
  void onClose() {
    // Dispose of the YouTube controller to prevent memory leaks.
    youtubeController?.dispose();
    super.onClose();
  }
}
