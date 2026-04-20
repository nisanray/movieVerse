import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/domain/entities/media.dart';
import '../../domain/repositories/watched_repository.dart';

class WatchedRepositoryImpl implements WatchedRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> addToWatched(String userId, Media media) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('watched')
          .doc(media.id.toString())
          .set(media.toMap());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeFromWatched(String userId, int mediaId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('watched')
          .doc(mediaId.toString())
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<List<Media>> getWatched(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('watched')
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Media.fromMap(doc.data())).toList();
    });
  }

  @override
  Future<bool> isWatched(String userId, int mediaId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('watched')
          .doc(mediaId.toString())
          .get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }
}

