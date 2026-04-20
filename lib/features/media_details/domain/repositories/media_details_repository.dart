import '../../../../core/domain/entities/media.dart';
import '../entities/media_details_entities.dart';

abstract class MediaDetailsRepository {
  Future<MediaDetails> getMediaDetails(int id, String type);
  Future<List<Media>> getSimilarMedia(int id, String type);
}

