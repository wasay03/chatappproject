import 'package:chatappproject/models/UserModel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chatappproject/screens/LoginPage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const HomePage({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              _signOut(context);
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: FutureBuilder<User?>(
        future: _getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show loading indicator while fetching user data
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // Show error message if fetching fails
          } else {
            User? user = snapshot.data;
            return Column(
              children: [
                ListTile(
                  title: Text(
                    'Hey ${user?.displayName.toString()}',
                    style: TextStyle(
                      fontSize: 30, // Increase the size for display name
                      fontWeight: FontWeight.bold,
                      color: Colors.orange, // Emphasize display name
                    ),
                  ),
                  subtitle: Text('Start Exploring Resources'),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SearchBar(
                    leading: Icon(Icons.search),
                    trailing: [Icon(Icons.delete_forever_sharp)],
                    hintText: "Search by name",
                    elevation: MaterialStateProperty.resolveWith<double?>((_) => 20),
                  ),
                ),
                Padding(padding: EdgeInsets.all(8)),
                SizedBox(
                  height: 553,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      color: Colors.blueGrey.shade200,
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            label: "Create",
            icon: Icon(Icons.create_outlined),
          ),
          BottomNavigationBarItem(
            label: "Profile",
            icon: Icon(Icons.portrait),
          ),
        ],
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

  Future<User?> _getUser() async {
    return FirebaseAuth.instance.currentUser;
  }
}
