import '../entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get onAuthStateChanged;
  
  Future<UserEntity?> signInWithEmail(String email, String password);
  Future<UserEntity?> signUpWithEmail(String email, String password);
  Future<UserEntity?> signInWithGoogle();
  Future<void> signOut();
  Future<UserEntity?> getCurrentUser();
  Future<void> sendPasswordResetEmail(String email);
}
