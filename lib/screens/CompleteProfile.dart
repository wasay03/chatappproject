import 'dart:io';
import 'package:chatappproject/models/UIHelper.dart';
import 'package:chatappproject/models/UserModel.dart';
import 'package:chatappproject/providers/profile_provider.dart';
import 'package:chatappproject/screens/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompleteProfile extends ConsumerWidget {
  final UserModel userModel;
  final User firebaseUser;

  const CompleteProfile({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);

  void selectImage(ImageSource source, WidgetRef ref) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      cropImage(pickedFile, ref);
    }
  }

  void cropImage(XFile file, WidgetRef ref) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 20,
    );

    if (croppedImage != null) {
      ref.read(imageProvider.notifier).state = File(croppedImage.path);
    }
  }

  void showPhotoOptions(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Upload Profile Picture"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.gallery, ref);
                },
                leading: Icon(Icons.photo_album),
                title: Text("Select from Gallery"),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.camera, ref);
                },
                leading: Icon(Icons.camera_alt),
                title: Text("Take a photo"),
              ),
            ],
          ),
        );
      },
    );
  }

  void checkValues(BuildContext context, WidgetRef ref) {
    String fullname = ref.read(userProvider).fullname ?? '';
    File? imageFile = ref.read(imageProvider.notifier).state;

    if (fullname.isEmpty || imageFile == null) {
      print("Please fill all the fields");
      UIHelper.showAlertDialog(
        context,
        "Incomplete Data",
        "Please fill all the fields and upload a profile picture",
      );
    } else {
      print("Uploading data..");
      uploadData(context, ref);
    }
  }

  void uploadData(BuildContext context, WidgetRef ref) async {
    UIHelper.showLoadingDialog(context, "Uploading image..");

    File? imageFile = ref.read(imageProvider.notifier).state;

    UploadTask uploadTask = FirebaseStorage.instance
        .ref("profilepictures")
        .child(userModel.uid.toString())
        .putFile(imageFile!);

    TaskSnapshot snapshot = await uploadTask;

    String imageUrl = await snapshot.ref.getDownloadURL();
    String fullname = ref.read(userProvider).fullname!;

    UserModel updatedUser = userModel;
    updatedUser.fullname = fullname;
    updatedUser.profilepic = imageUrl;

    await FirebaseFirestore.instance.collection("users").doc(updatedUser.uid).set(updatedUser.toMap()).then((value) {
      ref.read(userProvider.notifier).updateUser(updatedUser);
      print("Data uploaded!");
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return HomePage(userModel: updatedUser, firebaseUser: firebaseUser);
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fullNameController = TextEditingController(text: userModel.fullname);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text("Complete Profile"),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: ListView(
            children: [
              SizedBox(height: 20),
              CupertinoButton(
                onPressed: () {
                  showPhotoOptions(context, ref);
                },
                padding: EdgeInsets.all(0),
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: ref.watch(imageProvider) != null ? FileImage(ref.watch(imageProvider)!) : null,
                  child: ref.watch(imageProvider) == null ? Icon(Icons.person, size: 60) : null,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: fullNameController,
                decoration: InputDecoration(
                  labelText: "Full Name",
                ),
                onChanged: (value) {
                  ref.read(userProvider.notifier).updateUserName(value);
                },
              ),
              SizedBox(height: 20),
              CupertinoButton(
                onPressed: () {
                  checkValues(context, ref);
                },
                color: Theme.of(context).colorScheme.secondary,
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
