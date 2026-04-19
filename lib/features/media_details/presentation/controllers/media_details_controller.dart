import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../media_discovery/domain/entities/media.dart';
import '../../domain/entities/media_details_entities.dart';
import '../../domain/repositories/media_details_repository.dart';

/// [MediaDetailsController] manages the state for the Media Details screen.
/// It handles complex data fetching (Details, Cast, Videos, Similar) and the YouTube player lifecycle.
class MediaDetailsController extends GetxController
    with StateMixin<MediaDetails> {
  final MediaDetailsRepository _repository;
  final int mediaId;
  final String mediaType;

  MediaDetailsController(this._repository, this.mediaId, this.mediaType);

  /// Controller for the YouTube player to play movie trailers.
  YoutubePlayerController? youtubeController;

  /// Observable to notify the UI when the trailer is ready to be played.
  final RxBool isTrailerReady = false.obs;

  /// Observable list for similar media recommendations.
  final RxList<Media> similarMedia = <Media>[].obs;

  /// Observable list for all available videos (trailers, teasers, clips).
  final RxList<Video> allVideos = <Video>[].obs;

  /// Currently selected video index.
  final RxInt currentVideoIndex = 0.obs;

  /// Observable for fullscreen mode.
  final RxBool isFullScreen = false.obs;

  /// Observable for picture-in-picture mode.
  final RxBool isPiPMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Load media details and similar media immediately.
    fetchMediaDetails();
  }

  /// Fetches the complete media details and similar content in parallel.
  Future<void> fetchMediaDetails() async {
    try {
      change(null, status: RxStatus.loading());

      // Execute both detail fetching and similar media fetching in parallel.
      final results = await Future.wait([
        _repository.getMediaDetails(mediaId, mediaType),
        _repository.getSimilarMedia(mediaId, mediaType),
      ]);

      final MediaDetails details = results[0] as MediaDetails;
      final List<Media> similar = results[1] as List<Media>;

      similarMedia.assignAll(similar);

      // Store all YouTube videos for related trailers feature.
      if (details.videos.isNotEmpty) {
        final List<Video> videos = details.videos.cast<Video>();
        final youtubeVideos = videos.where((v) => v.site == 'YouTube').toList();
        allVideos.assignAll(youtubeVideos);

        // Initialize YouTube player with the first trailer if available.
        if (youtubeVideos.isNotEmpty) {
          _initializePlayer(youtubeVideos[0].key);
        }
      }

      change(details, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  /// Initializes the YouTube player with the given video ID.
  void _initializePlayer(String videoId) {
    youtubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: true,
      ),
    );
    isTrailerReady.value = true;
  }

  /// Changes the currently playing video.
  void changeVideo(int index) {
    if (index >= 0 && index < allVideos.length) {
      currentVideoIndex.value = index;
      _initializePlayer(allVideos[index].key);
    }
  }

  /// Toggles fullscreen mode.
  void toggleFullScreen() {
    isFullScreen.value = !isFullScreen.value;
  }

  /// Toggles picture-in-picture mode.
  void togglePiP() {
    isPiPMode.value = !isPiPMode.value;
  }

  @override
  void onClose() {
    youtubeController?.dispose();
    super.onClose();
  }
}
