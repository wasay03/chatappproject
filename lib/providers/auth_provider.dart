import 'package:chatappproject/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod 
Future<AuthenticationService> authenticationService(AuthenticationServiceRef ref) async{
  
return AuthenticationService(FirebaseAuth.instance);
}




class PasswordVisibilityNotifier extends StateNotifier<bool> {
  PasswordVisibilityNotifier() : super(false);

  void toggle() {
    state = !state;
  }
}

final passwordVisibilityProvider = StateNotifierProvider<PasswordVisibilityNotifier, bool>((ref) {
  return PasswordVisibilityNotifier();
});