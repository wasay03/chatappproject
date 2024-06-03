// ignore_for_file: prefer_const_constructors

import 'package:chatappproject/models/UserModel.dart';
import 'package:chatappproject/screens/ForgotPasswordPage.dart';
import 'package:chatappproject/screens/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    final showPassword = ref.watch(passwordVisibilityProvider);

    return Scaffold(
      body: SafeArea(
        child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  
                  Text(
                    "Chat Link",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 40,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 50,),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: "Your email"),
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: 
                      
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(hintText: "Your password"),
                        obscureText: !showPassword,
                      ),
                      trailing:IconButton(onPressed: (){ref.read(passwordVisibilityProvider.notifier).toggle();}, icon:(showPassword)? Icon(Icons.visibility_off):Icon(Icons.visibility))
                    ,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                      );
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    ),
                    ),
                  
                  SizedBox(height: 20),
                  CupertinoButton(
                    onPressed: authServiceAsync.when(
                      data: (authService) => () async {
                        try {
                          UserCredential userCredential = (await authService.signInWithEmailAndPassword(_emailController.text.trim(),_passwordController.text.trim())) as UserCredential;
                          User? user = userCredential.user;
                          if (user != null) {
                            // Assuming you have a method to get UserModel from Firebase User
                            UserModel? userModel = await authService.getUserModel(userCredential.user!);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => HomePage(userModel: userModel!, firebaseUser: user!)),
                            );
                          }else{
                            
                          }
                        }on FirebaseAuthException catch (e) {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Login Error"),
                                content: Text(e.toString()),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("OK"),
                                  ),
                                ],
                              ),
                            );

                          print(e.toString());
                        }
                      },
                      loading: () => null,
                      error: (error, stack) => null,
                    ),
                    child: Text("Login"),
                    color:  Theme.of(context).colorScheme.primary,
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
                            UserModel? userModel = await authService.getUserModel(userCredential.user!);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => HomePage(userModel: userModel!, firebaseUser: user!)),
                            );
                          }else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Sign Up Error"),
                                content: Text(""),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("OK"),
                                  ),
                                ],
                              ),
                            );
                                                }
                        } catch (e) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Sign Up Error"),
                              content: Text(e.toString()),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("OK"),
                                ),
                              ],
                            ),
                          );
                          print(e.toString());
                        }
                      },
                      loading: () => null,
                      error: (error, stack) => null,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: SizedBox(
                          height: 50,
                          width: 170,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                
                                Icon(FontAwesomeIcons.google),
                                SizedBox(width: 5),
                                Expanded(child: Text("Sign in with Google")),
                              ],
                            ),
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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
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
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
