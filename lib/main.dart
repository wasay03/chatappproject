// ignore_for_file: prefer_const_constructors

import 'package:chatappproject/firebase_options.dart';
import 'package:chatappproject/providers/auth_provider.dart';
import 'package:chatappproject/screens/CompleteProfile.dart';
import 'package:chatappproject/screens/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chatappproject/screens/LoginPage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartPage(),
    );
  }
}

class StartPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Something Went wrong"),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return AuthChecker();
        }
        //loading
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class AuthChecker extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _authState = ref.watch(authenticationServiceProvider);
    return _authState.when(
      data: (value) {
        if (value != null) {
          return HomePage();
        }
        return LoginPage();
      },
      loading: () {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      error: (_, __) {
        return Scaffold(
          body: Center(
            child: Text("Error occured"),
          ),
        );
      },
    );
  }
}