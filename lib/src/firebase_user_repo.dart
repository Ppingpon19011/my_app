import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/my_user.dart';
import 'user_repository.dart';

class FirebaseUserRepo implements UserRepository {
  final FirebaseAuth _firebaseAuth;
  final usersCollection = FirebaseFirestore.instance.collection('users');
  
  FirebaseUserRepo({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Stream<MyUser?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null
          ? MyUser.empty
          : MyUser(
              id: firebaseUser.uid,
              email: firebaseUser.email!,
              name: firebaseUser.displayName,
              photoUrl: firebaseUser.photoURL,
            );
    });
  }
  
  @override
  MyUser get currentUser {
    final firebaseUser = _firebaseAuth.currentUser;
    return firebaseUser == null
        ? MyUser.empty
        : MyUser(
            id: firebaseUser.uid,
            email: firebaseUser.email!,
            name: firebaseUser.displayName,
            photoUrl: firebaseUser.photoURL,
          );
  }

  @override
  Future<MyUser> signUp(MyUser user, String password) async {
    try {
      UserCredential credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );
      
      await credential.user!.updateDisplayName(user.name);
      
      return user.copyWith(id: credential.user!.uid);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  
  @override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  
  @override
  Future<void> setUserData(MyUser user) async {
    try {
      await usersCollection.doc(user.id).set({
        'email': user.email,
        'name': user.name,
        'photoUrl': user.photoUrl,
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}