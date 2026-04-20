import '../../../../core/domain/entities/media.dart';
import '../repositories/watch_later_repository.dart';

class GetWatchLaterUseCase {
  final WatchLaterRepository repository;
  GetWatchLaterUseCase(this.repository);

  Stream<List<Media>> execute(String userId) {
    return repository.getWatchLater(userId);
  }
}

