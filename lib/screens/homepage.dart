import 'package:chatappproject/models/UserModel.dart';
import 'package:chatappproject/screens/CompleteProfile.dart';
import 'package:chatappproject/screens/EditProfile.dart';
import 'package:chatappproject/screens/SearchPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chatappproject/screens/LoginPage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const HomePage({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);
  




  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Messenger"),
        leading: IconButton(icon: Icon(Icons.edit_square),onPressed:(){Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfile(userModel:userModel,
        firebaseUser: FirebaseAuth.instance.currentUser!,)));}),
        actions: [
          
          IconButton(
            onPressed: () {
              _signOut(context);
            },
            icon: const Icon(Icons.logout),
          )
        ],
      
      ),
      body: SafeArea(child: Container()),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchPage(userModel:userModel,
        firebaseUser: FirebaseAuth.instance.currentUser!,)));
        },
        child: Icon(Icons.search),
        ),
      
      
      
    );
  }

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    GoogleSignIn().signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to your login screen after sign out
    );
  }
   Future<void> _editProfile (BuildContext context,UserModel userModel,User firebaseUser)async{

     
  }

  Future<User?> _getUser() async {
    return FirebaseAuth.instance.currentUser;
  }
}
