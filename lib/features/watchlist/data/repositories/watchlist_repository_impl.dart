import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../movie_discovery/domain/entities/media.dart';
import '../../domain/repositories/watchlist_repository.dart';

class WatchlistRepositoryImpl implements WatchlistRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> addToWatchlist(String userId, Media media) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('watchlist')
          .doc(media.id.toString())
          .set(media.toMap());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeFromWatchlist(String userId, int mediaId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('watchlist')
          .doc(mediaId.toString())
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<List<Media>> getWatchlist(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('watchlist')
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Media.fromMap(doc.data())).toList();
    });
  }

  @override
  Future<bool> isInWatchlist(String userId, int mediaId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('watchlist')
          .doc(mediaId.toString())
          .get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }
}
