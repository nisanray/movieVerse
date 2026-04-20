import '../../../../core/domain/entities/media.dart';
import '../../domain/repositories/actor_repository.dart';
import '../datasources/actor_remote_data_source.dart';

class ActorRepositoryImpl implements ActorRepository {
  final ActorRemoteDataSource remoteDataSource;

  ActorRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Media>> getMediaByActor(int actorId) async {
    return await remoteDataSource.getMediaByActor(actorId);
  }
}
