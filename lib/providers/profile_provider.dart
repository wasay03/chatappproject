  import 'package:riverpod_annotation/riverpod_annotation.dart';
  import 'package:chatappproject/services/profileService.dart';

  part 'profile_provider.g.dart';

  @riverpod
  Future<ProfileService> profileService(ProfileServiceRef ref) async{
    return ProfileService();
  }
