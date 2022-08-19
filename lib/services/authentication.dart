import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication with ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  late String userUid;
  String get getUserId => userUid;

  Future logIntoAccount(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      User user = userCredential.user!;
      userUid = user.uid;
      //print('userId => $userUid');
      notifyListeners();
    } catch (e) {
      print('error => $e');
    }
  }

  Future createAccount(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;
      userUid = user!.uid;
      // ignore: avoid_print
      //print(' userid => $userUid');
      notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential authCredential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential userCredential =
        await firebaseAuth.signInWithCredential(authCredential);

    final User? user = userCredential.user;
    assert(user?.uid != null);

    userUid = user!.uid;

    //print("user uid => $userUid");

    notifyListeners();
  }

  Future logOutWithEmail() async {
    return firebaseAuth.signOut();
  }

  Future signOutWithGoogle() async {
    return googleSignIn.signOut();
  }
}
