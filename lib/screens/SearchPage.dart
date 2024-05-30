import 'dart:developer';
import 'package:chatappproject/models/ChatRoomModel.dart';
import 'package:chatappproject/models/UserModel.dart';
import 'package:chatappproject/providers/chatroom_provider.dart';
import 'package:chatappproject/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SearchPage extends ConsumerWidget {
  final UserModel userModel;
  final User firebaseUser;

  const SearchPage({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);

  Future<ChatRoomModel?> getChatroomModel(UserModel targetUser, WidgetRef ref) async {
    ChatRoomModel? chatRoom;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${userModel.uid}", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var docData = snapshot.docs[0].data() as Map<String, dynamic>;
      ChatRoomModel existingChatroom = ChatRoomModel.fromMap(docData);
      chatRoom = existingChatroom;
    } else {
      ChatRoomModel newChatroom = ChatRoomModel(
        chatroomid: DateTime.now().millisecondsSinceEpoch.toString(),
        participants: [userModel.uid!, targetUser.uid!],
      );

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatroom.chatroomid)
          .set(newChatroom.toMap());

      chatRoom = newChatroom;
      log("New Chatroom Created!");
    }

    ref.read(chatRoomProvider.notifier).setChatRoom(chatRoom);
    return chatRoom;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(labelText: "Email Address"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  ref.read(userProvider.notifier).clearUser();
                },
                child: Text("Search"),
              ),
              SizedBox(height: 20),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .where("email", isEqualTo: searchController.text)
                    .where("email", isNotEqualTo: userModel.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;
                      if (dataSnapshot.docs.isNotEmpty) {
                        Map<String, dynamic> userMap = dataSnapshot.docs[0].data() as Map<String, dynamic>;
                        UserModel searchedUser = UserModel.fromMap(userMap);

                        return ListTile(
                          onTap: () async {
                            ChatRoomModel? chatroomModel = await getChatroomModel(searchedUser, ref);
                            if (chatroomModel != null) {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return (HomePage(userModel: userModel, firebaseUser: firebaseUser));
                                  // return ChatRoomPage(
                                  //   targetUser: searchedUser,
                                  //   userModel: userModel,
                                  //   firebaseUser: firebaseUser,
                                  //   chatroom: chatroomModel,
                                  // );
                                },
                              ));
                            }
                          },
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(searchedUser.profilepic!),
                            backgroundColor: Colors.grey[500],
                          ),
                          title: Text(searchedUser.fullname!),
                          subtitle: Text(searchedUser.email!),
                          trailing: Icon(Icons.keyboard_arrow_right),
                        );
                      } else {
                        return Text("No results found!");
                      }
                    } else if (snapshot.hasError) {
                      return Text("An error occurred!");
                    } else {
                      return Text("No results found!");
                    }
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
