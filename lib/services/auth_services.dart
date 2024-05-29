import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:chatappproject/models/UserModel.dart';
import 'package:google_sign_in/google_sign_in.dart';


 

class AuthenticationService{
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      String uid = userCredential.user!.uid;
      DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return UserModel.fromMap(userData.data() as Map<String, dynamic>);
    } catch (e) {
      throw e;
    }
  }
  
  Future<UserModel?> signInWithGoogle() async {
  try {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

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

      // Fetch the user data
      DocumentSnapshot userData = await userDocRef.get();
      return UserModel.fromMap(userData.data() as Map<String, dynamic>);
    }
  } catch (e) {
    throw e;
  }
  return null;
}
  Future<void> signOut() async{
    await _firebaseAuth.signOut();
  }
}