import '../repositories/watched_repository.dart';

class RemoveFromWatchedUseCase {
  final WatchedRepository repository;
  RemoveFromWatchedUseCase(this.repository);

  Future<void> execute(String userId, int mediaId) {
    return repository.removeFromWatched(userId, mediaId);
  }
}
