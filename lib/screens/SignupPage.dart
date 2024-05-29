import 'package:chatappproject/models/UserModel.dart';
import 'package:chatappproject/services/signup_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatappproject/models/UserModel.dart';
import 'package:chatappproject/screens/CompleteProfile.dart';
import 'package:chatappproject/services/signup_service.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cPasswordController = TextEditingController();

  final SignUpService signUpService = SignUpService();

  void checkValues(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cPassword = cPasswordController.text.trim();

    final result = await signUpService.checkValues(email, password, cPassword);
    if (result != "User created") {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Sign Up Error"),
          content: Text(result!),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    } else {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      if (credential != null) {
        String uid = credential.user!.uid;
        UserModel newUser = UserModel(
          uid: uid,
          email: email,
          fullname: "",
          profilepic: "",
        );
        await FirebaseFirestore.instance.collection("users").doc(uid).set(newUser.toMap()).then((value) {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return CompleteProfile(userModel: newUser, firebaseUser: credential.user!);
              },
            ),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "Chat App",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: "Email Address"),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Password"),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: cPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Confirm Password"),
                  ),
                  SizedBox(height: 20),
                  CupertinoButton(
                    onPressed: () => checkValues(context),
                    color: Theme.of(context).colorScheme.secondary,
                    child: Text("Sign Up"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Already have an account?",
              style: TextStyle(fontSize: 16),
            ),
            CupertinoButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Log In",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
