import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String _collection = 'users';

  @override
  Stream<UserEntity?> getUserProfile(String uid) {
    return _firestore
        .collection(_collection)
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (doc.exists && doc.data() != null) {
        return UserModel.fromFirestore(doc.data()!, uid);
      }
      return null;
    });
  }

  @override
  Future<void> updateProfile(UserEntity user) async {
    final model = UserModel(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoUrl,
      bio: user.bio,
    );

    await _firestore
        .collection(_collection)
        .doc(user.uid)
        .set(model.toFirestore(), SetOptions(merge: true));
  }

  @override
  Future<String> uploadProfilePicture(String uid, File image) async {
    try {
      final ref = _storage.ref().child('profile_pictures').child('$uid.jpg');
      
      // Upload task
      final uploadTask = await ref.putFile(
        image,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }
}
