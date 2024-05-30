import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatappproject/models/UserModel.dart';

// Provider for managing the user model
final userProvider = StateNotifierProvider<UserNotifier, UserModel>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<UserModel> {
  UserNotifier() : super(UserModel());

  void updateUser(UserModel user) {
    state = user;
  }

  void updateUserName(String fullname) {
    state = UserModel(
      uid: state.uid,
      fullname: fullname,
      email: state.email,
      profilepic: state.profilepic,
    );
  }

  void updateProfilePic(String profilePicUrl) {
    state = UserModel(
      uid: state.uid,
      fullname: state.fullname,
      email: state.email,
      profilepic: profilePicUrl,
    );
  }
}

// Provider for managing image file
final imageProvider = StateProvider<File?>((ref) => null);
