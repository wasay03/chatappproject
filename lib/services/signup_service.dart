import 'package:chatappproject/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpService {
  Future<String?> checkValues(String email, String password, String confirmPassword) async {
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      return "Please fill all the fields";
    } else if (password != confirmPassword) {
      return "The passwords you entered do not match!";
    } else {
      return await signUp(email, password);
    }
  }

  Future<String?> signUp(String email, String password) async {
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      return e.message;
    }

    if (credential != null) {
      String uid = credential.user!.uid;
      UserModel newUser = UserModel(
        uid: uid,
        email: email,
        fullname: "",
        profilepic: "",
      );
      await FirebaseFirestore.instance.collection("users").doc(uid).set(newUser.toMap());
      return "User created";
    }
    return "Error creating user";
  }
}
