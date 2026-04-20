import '../../../../core/domain/entities/media.dart';

abstract class ActorRepository {
  Future<List<Media>> getMediaByActor(int actorId);
}
