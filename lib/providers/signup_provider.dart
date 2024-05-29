import 'package:chatappproject/services/signup_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'signup_provider.g.dart';

@riverpod
Future<SignUpService> signUpService(SignUpServiceRef ref) async{
  return SignUpService();
}