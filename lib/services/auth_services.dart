import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:chatappproject/models/UserModel.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User?> authStateChange() => _firebaseAuth.authStateChanges();

  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      throw e;
    }
  }

  Future<UserModel> getUserModel(User user) async {
    String uid = user.uid;
    DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return UserModel.fromMap(userData.data() as Map<String, dynamic>);
  }
  
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);

        String uid = userCredential.user!.uid;

        // Reference to the user's document in Firestore
        DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(uid);

        // Check if the user document exists
        DocumentSnapshot userDocSnapshot = await userDocRef.get();

        // If the user document does not exist, create it
        if (!userDocSnapshot.exists) {
          await userDocRef.set({
            'uid': uid,
            'email': userCredential.user!.email,
            'name': googleSignInAccount.displayName,
            'photoUrl': googleSignInAccount.photoUrl,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }

        return userCredential;
      }
    } catch (e) {
      throw e;
    }
    return null;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future <bool>  showPassword() async{
    return false;
  }
}
