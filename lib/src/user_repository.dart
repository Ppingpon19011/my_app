import 'dart:async';
import 'models/my_user.dart';

abstract class UserRepository {
  Stream<MyUser?> get user;
  
  MyUser get currentUser;

  Future<MyUser> signUp(MyUser user, String password);
  
  Future<void> signIn(String email, String password);
  
  Future<void> logOut();
  
  Future<void> resetPassword(String email);
  
  Future<void> setUserData(MyUser user);
}