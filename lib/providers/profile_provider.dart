import 'dart:io';
import 'package:chatappproject/models/UserModel.dart';
import 'package:chatappproject/services/profileService.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_provider.g.dart';



@riverpod
Future<ProfileService> profileService(ProfileServiceRef ref) async {
  return ProfileService();
}

