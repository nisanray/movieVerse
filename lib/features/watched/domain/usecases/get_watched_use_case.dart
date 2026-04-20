import '../../../../core/domain/entities/media.dart';
import '../repositories/watched_repository.dart';

class GetWatchedUseCase {
  final WatchedRepository repository;
  GetWatchedUseCase(this.repository);

  Stream<List<Media>> execute(String userId) {
    return repository.getWatched(userId);
  }
}

