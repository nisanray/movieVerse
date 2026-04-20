import '../../../../core/domain/entities/media.dart';

abstract class WatchedRepository {
  Future<void> addToWatched(String userId, Media media);
  Future<void> removeFromWatched(String userId, int mediaId);
  Stream<List<Media>> getWatched(String userId);
  Future<bool> isWatched(String userId, int mediaId);
}

