import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // instance of AuthService
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseAuth get auth => _auth;

  //sign in
  Future<UserCredential> signInWithEmailAndPasswordToFirebase(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception("something went wrong signing a user in ${e.code}");
    }
  }

  //sign up
  Future<UserCredential> createUserWithEmailAndPasswordToFirebase(
      String email, String password) async {
    try {
      Future<UserCredential> userCredential = _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception("something went wrong creating a new user ${e.code}");
    }
  }

  //sign out
  Future<void> signOutFromFirebase() async {
    try {
      return await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw Exception("something went wrong creating a new user ${e.code}");
    }
  }

  // errors
}
