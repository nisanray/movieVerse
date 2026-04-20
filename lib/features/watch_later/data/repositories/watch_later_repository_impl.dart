import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../media_discovery/domain/entities/media.dart';
import '../../domain/repositories/watch_later_repository.dart';

class WatchLaterRepositoryImpl implements WatchLaterRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> addToWatchLater(String userId, Media media) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('watch_later')
          .doc(media.id.toString())
          .set(media.toMap());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeFromWatchLater(String userId, int mediaId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('watch_later')
          .doc(mediaId.toString())
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<List<Media>> getWatchLater(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('watch_later')
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Media.fromMap(doc.data())).toList();
    });
  }

  @override
  Future<bool> isInWatchLater(String userId, int mediaId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('watch_later')
          .doc(mediaId.toString())
          .get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }
}
