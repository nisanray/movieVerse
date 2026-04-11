import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../movie_discovery/domain/entities/media.dart';
import '../../domain/entities/movie_details_entities.dart';
import '../../domain/repositories/movie_details_repository.dart';

/// [MovieDetailsController] manages the state for the Media Details screen.
/// It handles complex data fetching (Details, Cast, Videos, Similar) and the YouTube player lifecycle.
class MovieDetailsController extends GetxController with StateMixin<MovieDetails> {
  final MovieDetailsRepository _repository;
  final int movieId;
  final String mediaType;

  MovieDetailsController(this._repository, this.movieId, this.mediaType);

  /// Controller for the YouTube player to play movie trailers.
  YoutubePlayerController? youtubeController;
  
  /// Observable to notify the UI when the trailer is ready to be played.
  final RxBool isTrailerReady = false.obs;

  /// Observable list for similar media recommendations.
  final RxList<Media> similarMedia = <Media>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Load movie details and similar media immediately.
    fetchMovieDetails();
  }

  /// Fetches the complete media details and similar content in parallel.
  Future<void> fetchMovieDetails() async {
    try {
      change(null, status: RxStatus.loading());
      
      // Execute both detail fetching and similar media fetching in parallel.
      final results = await Future.wait([
        _repository.getMovieDetails(movieId, mediaType),
        _repository.getSimilarMedia(movieId, mediaType),
      ]);

      final MovieDetails details = results[0] as MovieDetails;
      final List<Media> similar = results[1] as List<Media>;

      similarMedia.assignAll(similar);
      
      // Attempt to initialize the YouTube player if trailers are found.
      if (details.videos.isNotEmpty) {
        final List<Video> videos = details.videos.cast<Video>();
        
        // Prioritize official 'Trailer' types from 'YouTube'.
        final trailerResults = videos.where((v) => v.type == 'Trailer' && v.site == 'YouTube');
        
        if (trailerResults.isNotEmpty) {
          final trailer = trailerResults.first;
          youtubeController = YoutubePlayerController(
            initialVideoId: trailer.key,
            flags: const YoutubePlayerFlags(
              autoPlay: false,
              mute: false,
            ),
          );
          isTrailerReady.value = true;
        }
      }
      
      change(details, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  @override
  void onClose() {
    youtubeController?.dispose();
    super.onClose();
  }
}
