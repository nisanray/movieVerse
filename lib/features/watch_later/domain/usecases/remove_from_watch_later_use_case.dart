import '../repositories/watch_later_repository.dart';

class RemoveFromWatchLaterUseCase {
  final WatchLaterRepository repository;
  RemoveFromWatchLaterUseCase(this.repository);

  Future<void> execute(String userId, int mediaId) {
    return repository.removeFromWatchLater(userId, mediaId);
  }
}
