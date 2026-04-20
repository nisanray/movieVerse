import '../../../../core/domain/entities/media.dart';
import '../repositories/watch_later_repository.dart';

class AddToWatchLaterUseCase {
  final WatchLaterRepository repository;
  AddToWatchLaterUseCase(this.repository);

  Future<void> execute(String userId, Media media) {
    return repository.addToWatchLater(userId, media);
  }
}

