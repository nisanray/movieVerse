import '../../../../core/api/api_client.dart';
import '../../../../core/data/models/media_model.dart';

abstract class ActorRemoteDataSource {
  Future<List<MediaModel>> getMediaByActor(int actorId);
}

class ActorRemoteDataSourceImpl implements ActorRemoteDataSource {
  final ApiClient apiClient;

  ActorRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<MediaModel>> getMediaByActor(int actorId) async {
    final response = await apiClient.getData('/person/$actorId/combined_credits');
    if (response.data != null && response.data['cast'] != null) {
      final List results = response.data['cast'];
      return results.map((json) => MediaModel.fromJson(json)).toList();
    }
    return [];
  }
}
