import 'dart:io';
import '../entities/user_entity.dart';

abstract class UserRepository {
  /// Fetches a stream of continuous updates for the user profile.
  Stream<UserEntity?> getUserProfile(String uid);

  /// Updates specific fields of the user profile.
  Future<void> updateProfile(UserEntity user);

  /// Uploads a profile picture and returns the URL.
  Future<String> uploadProfilePicture(String uid, File image);
}
