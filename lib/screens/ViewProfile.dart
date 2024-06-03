// ignore_for_file: prefer_const_constructors


import 'package:chatappproject/models/ChatRoomModel.dart';
import 'package:chatappproject/providers/home_provider.dart';
import 'package:chatappproject/screens/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chatappproject/models/UserModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';

class ViewProfile extends ConsumerWidget {
  final UserModel user;
  final ChatRoomModel chatroom;

  const ViewProfile({Key? key, required this.user,required this.chatroom}) : super(key: key);

Future<void> deleteConvo(String chatroomId,ref)async{
  final firestore=ref.read(firebaseFirestoreProvider);
  await firestore.collection("chatrooms").doc(chatroomId).delete();
  
}
Future<void> deleteMessages(String chatroomId) async {
  final firestore = FirebaseFirestore.instance;
  final messagesRef = firestore.collection("chatrooms").doc(chatroomId).collection("messages");

  // Fetch all documents in the subcollection
  final messagesSnapshot = await messagesRef.get();

  // Create a batch
  WriteBatch batch = firestore.batch();

  // Add each document delete operation to the batch
  for (var doc in messagesSnapshot.docs) {
    batch.delete(doc.reference);
  }

  // Commit the batch
  await batch.commit();
}

  Future<void> handleClick(int item,chatroomId,ref) async {
  switch (item) {
    case 0:
      deleteConvo(chatroomId, ref);
      break;
    case 1:
      break;
  }
}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(

      appBar: AppBar(
      backgroundColor:Colors.lightGreenAccent.shade100,

      actions: <Widget>[
      PopupMenuButton<int>(
          onSelected: (item) => handleClick(item,chatroom.chatroomid,ref).then((value) => {Navigator.popUntil(context,(route)=>route.isFirst)}),
          itemBuilder: (context) => [
            PopupMenuItem<int>(value: 0, child: Text('Delete Conversation')),
          ],
        ),
    ],
  ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user.profilepic.toString()),
              ),
              SizedBox(height: 20),
              Text(
                user.fullname.toString(),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                user.email.toString(),
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
              SizedBox(height: 20),
              
            ],
          ),
        ),
      ),
    );
  }
}
