import 'package:chatappproject/models/UserModel.dart';
import 'package:chatappproject/screens/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chatappproject/providers/auth_provider.dart';
import 'package:chatappproject/screens/SignupPage.dart';

class LoginPage extends ConsumerWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  User? user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authServiceAsync = ref.watch(authenticationServiceProvider);

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "Messenger",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 40,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: "Your email"),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(hintText: "Your password"),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  CupertinoButton(
                    onPressed: authServiceAsync.when(
                      data: (authService) => () async {
                        try {
                          await authService.signInWithEmailAndPassword(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                          ).then((_) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Placeholder()),
                            );
                          });
                        } catch (e) {
                          print(e.toString());
                        }
                      },
                      loading: () => null,
                      error: (error, stack) => null,
                    ),
                    child: Text("Login"),
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  Text("Or"),
                  GestureDetector(
                    onTap: authServiceAsync.when(
                      data: (authService) => () async {
                        try {
                          UserCredential userCredential = (await authService.signInWithGoogle()) as UserCredential;
                          User? user = userCredential.user;
                          if (user != null) {
                            // Assuming you have a method to get UserModel from Firebase User
                            UserModel? userModel = await authService.getUser(userCredential.user!);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => HomePage(userModel: userModel!, firebaseUser: user!)),
                            );
                          }
                        } catch (e) {
                          print(e.toString());
                        }
                      },
                      loading: () => null,
                      error: (error, stack) => null,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                      child: Card(
                        elevation: 20,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: SizedBox(
                          height: 50,
                          width: 170,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(FontAwesomeIcons.google),
                              SizedBox(width: 5),
                              Text("Sign in with Google"),
                            ],
                          ),
                        ),
                      ),
                    ),
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
              "Don't have an account?",
              style: TextStyle(fontSize: 15),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              child: Text(
                "Sign Up",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
