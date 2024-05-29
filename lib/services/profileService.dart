import 'dart:io';
import 'package:chatappproject/models/UserModel.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileService {
  Future<File?> selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  Future<File?> cropImage(File file) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 20,
    );
    return croppedFile != null ? File(croppedFile.path) : null;
  }

  Future<String> uploadImage(File imageFile, String userId) async {
    UploadTask uploadTask = FirebaseStorage.instance.ref("profilepictures").child(userId).putFile(imageFile);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> updateUserProfile(UserModel userModel, String fullname, String imageUrl) async {
    userModel.fullname = fullname;
    userModel.profilepic = imageUrl;
    await FirebaseFirestore.instance.collection("users").doc(userModel.uid).set(userModel.toMap());
  }
}
