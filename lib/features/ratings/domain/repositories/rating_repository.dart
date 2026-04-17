import '../entities/rating_entity.dart';

abstract class RatingRepository {
  Future<void> saveRating(RatingEntity rating);
  Future<RatingEntity?> getUserRating(String uid, int mediaId);
}
