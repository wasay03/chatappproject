// ignore_for_file: prefer_const_constructors

import 'package:chatappproject/firebase_options.dart';
import 'package:chatappproject/models/UserModel.dart';
import 'package:chatappproject/providers/auth_provider.dart';
import 'package:chatappproject/screens/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen)),
      debugShowCheckedModeBanner: false,
      home: StartPage(),
    );
  }
}

class StartPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Something went wrong"),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return AuthChecker();
        }

        // loading
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
    final authService = ref.watch(authenticationServiceProvider);

    return authService.when(
      data: (service) {
        final authStateStream = service.authStateChange();
        return StreamBuilder<User?>(
          stream: authStateStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              final user = snapshot.data;
              if (user == null) {
                return LoginPage();
              } else {
                // Fetch UserModel from Firestore
                return FutureBuilder<UserModel?>(
                  future: service.getUserModel(user),
                  builder: (context, userModelSnapshot) {
                    if (userModelSnapshot.connectionState == ConnectionState.done) {
                      if (userModelSnapshot.hasError) {
                        return Scaffold(
                          body: Center(
                            child: Text("An error occurred: ${userModelSnapshot.error}"),
                          ),
                        );
                      }
                      UserModel? userModel = userModelSnapshot.data;
                      return HomePage(userModel: userModel!, firebaseUser: user);
                    } else {
                      return Scaffold(
                        body: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                );
              }
            } else {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        );
      },
      loading: () => Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Text("An error occurred: $error"),
        ),
      ),
    );
  }
}
