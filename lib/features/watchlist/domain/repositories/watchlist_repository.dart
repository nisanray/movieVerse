import '../../../movie_discovery/domain/entities/media.dart';

abstract class WatchlistRepository {
  Future<void> addToWatchlist(String userId, Media media);
  Future<void> removeFromWatchlist(String userId, int mediaId);
  Stream<List<Media>> getWatchlist(String userId);
  Future<bool> isInWatchlist(String userId, int mediaId);
}
