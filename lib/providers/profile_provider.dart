import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatappproject/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<void> fetchUser(String uid) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      state = UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }
  }
}

// Provider for managing image file
final imageProvider = StateProvider<File?>((ref) => null);
