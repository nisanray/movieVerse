import '../../../media_discovery/domain/entities/media.dart';

abstract class WatchLaterRepository {
  Future<void> addToWatchLater(String userId, Media media);
  Future<void> removeFromWatchLater(String userId, int mediaId);
  Stream<List<Media>> getWatchLater(String userId);
  Future<bool> isInWatchLater(String userId, int mediaId);
}
