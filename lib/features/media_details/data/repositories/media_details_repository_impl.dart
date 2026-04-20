import '../../../../core/domain/entities/media.dart';
import '../../domain/entities/media_details_entities.dart';
import '../../domain/repositories/media_details_repository.dart';
import '../datasources/media_details_remote_data_source.dart';

class MediaDetailsRepositoryImpl implements MediaDetailsRepository {
  final MediaDetailsRemoteDataSource remoteDataSource;

  MediaDetailsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<MediaDetails> getMediaDetails(int id, String type) async {
    return await remoteDataSource.getMediaDetails(id, type);
  }

  @override
  Future<List<Media>> getSimilarMedia(int id, String type) async {
    return await remoteDataSource.getSimilarMedia(id, type);
  }
}

