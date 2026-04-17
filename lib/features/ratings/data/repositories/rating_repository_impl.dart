import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/rating_model.dart';
import '../../domain/entities/rating_entity.dart';
import '../../domain/repositories/rating_repository.dart';

class RatingRepositoryImpl implements RatingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'ratings';

  @override
  Future<void> saveRating(RatingEntity rating) async {
    final model = RatingModel(
      uid: rating.uid,
      mediaId: rating.mediaId,
      mediaType: rating.mediaType,
      rating: rating.rating,
      genreIds: rating.genreIds,
      updatedAt: DateTime.now(),
    );

    // Document ID is a combination of UID and MediaID for unique per-user ratings
    final docId = '${rating.uid}_${rating.mediaId}';

    await _firestore
        .collection(_collection)
        .doc(docId)
        .set(model.toFirestore(), SetOptions(merge: true));
  }

  @override
  Future<RatingEntity?> getUserRating(String uid, int mediaId) async {
    final docId = '${uid}_${mediaId}';
    final doc = await _firestore.collection(_collection).doc(docId).get();

    if (doc.exists && doc.data() != null) {
      return RatingModel.fromFirestore(doc.data()!);
    }
    return null;
  }

  @override
  Future<List<RatingEntity>> getAllUserRatings(String uid) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('uid', isEqualTo: uid)
        .orderBy('updatedAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => RatingModel.fromFirestore(doc.data()))
        .toList();
  }
}
