import '../../../../core/domain/entities/media.dart';
import '../repositories/actor_repository.dart';

class GetMediaByActorUseCase {
  final ActorRepository repository;

  GetMediaByActorUseCase(this.repository);

  Future<List<Media>> execute(int actorId) async {
    return await repository.getMediaByActor(actorId);
  }
}
