import '../../../../core/domain/entities/media.dart';
import '../repositories/watched_repository.dart';
import '../../../watch_later/domain/repositories/watch_later_repository.dart';

class AddToWatchedUseCase {
  final WatchedRepository watchedRepository;
  final WatchLaterRepository watchLaterRepository;

  AddToWatchedUseCase({
    required this.watchedRepository,
    required this.watchLaterRepository,
  });

  Future<void> execute(String userId, Media media) async {
    // 1. Add to Watched
    await watchedRepository.addToWatched(userId, media);
    
    // 2. Automatically remove from Watch Later (Mutual Exclusivity)
    await watchLaterRepository.removeFromWatchLater(userId, media.id);
  }
}

