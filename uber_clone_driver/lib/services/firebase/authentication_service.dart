import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:uber_clone_driver/firebase_response_results/sign_in.dart';


class AuthenticationService {

  final FirebaseAuth _instance = FirebaseAuth.instance;
  Stream<User?>? get authStateChanges => FirebaseAuth.instance.authStateChanges();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  AuthenticationService() {
    if(currentUser != null) {
      print(currentUser!.uid);
    }
  }

  Future<UserCredential?> createAccount({required String email, required String password}) async {
    try {
      final UserCredential userCredential = await _instance.createUserWithEmailAndPassword(email: email, password: password)
          .timeout(const Duration(seconds: 2));
      return userCredential;
    }
    on TimeoutException catch(err) {
      print('Function took too long to complete');
      print(err.toString());
      return null;
    }
    on Exception catch (err) {
      print('There was a problem with the server');
      print(err.toString());
      return null;
    }
  }

  Future<SignInResult> signInWithEmail({required String email, required String password}) async {
    try {
      final UserCredential userCredential = await _instance.signInWithEmailAndPassword(email: email, password: password)
          .timeout(const Duration(seconds: 2));

      return SignInResult.success();
    }
    on TimeoutException catch(err) {
      print('Function took too long to complete');
      print(err.toString());
      return SignInResult.timeout();
    }
    on FirebaseAuthException catch (err) {
      print(err.toString());
      print('There was a problem with the server');
      return SignInResult.fromErrorCode(err.code);

    }
  }

  Future<void> signOut() async {
    await _instance.signOut();
  }



}