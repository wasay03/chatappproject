
// ignore_for_file: prefer_const_constructors

import 'package:chatappproject/models/ChatRoomModel.dart';
import 'package:chatappproject/models/UserModel.dart';
import 'package:chatappproject/providers/home_provider.dart';
import 'package:chatappproject/screens/ChatRoomPage.dart';
import 'package:chatappproject/screens/EditProfile.dart';
import 'package:chatappproject/screens/LoginPage.dart';
import 'package:chatappproject/screens/SearchPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  final UserModel userModel;
  final User firebaseUser;

  const HomePage({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatRoomsStream = ref.watch(chatRoomsStreamProvider(userModel.uid as String));

    return Scaffold(
      
      appBar: AppBar(
        backgroundColor:Colors.lightGreenAccent.shade100,
        
        
        leading:IconButton(icon: Icon(Icons.mode_edit_outline_outlined),onPressed:(){Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfile(userModel:userModel,
        firebaseUser: FirebaseAuth.instance.currentUser!,)));}),

        centerTitle: true,
        title: Text("Chat Link"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginPage();
                  }
                ),
              );
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: chatRoomsStream.when(
            data: (chatRoomSnapshot) {
              return ListView.builder(
                itemCount: chatRoomSnapshot.docs.length,
                itemBuilder: (context, index) {
                  ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(chatRoomSnapshot.docs[index].data() as Map<String, dynamic>);

                  Map<String, dynamic> participants = chatRoomModel.participants!;
                  List<String> participantKeys = participants.keys.toList();
                  participantKeys.remove(userModel.uid);

                  return Consumer(
                    builder: (context, ref, child) {
                      final userData = ref.watch(userModelProvider(participantKeys[0]));
                      return userData.when(
                        data: (targetUser) {
                          if (targetUser != null) {
                            return Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              elevation: 5,
                              color: Colors.white,
                              child: Container(
                                decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/bg.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return ChatRoomPage(
                                          chatroom: chatRoomModel,
                                          firebaseUser: firebaseUser,
                                          userModel: userModel,
                                          targetUser: targetUser,
                                        );
                                      }),
                                    );
                                  },
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: NetworkImage(targetUser.profilepic.toString(),),
                                  ),
                                  title: Text(targetUser.fullname.toString(),style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.secondary)),
                                  subtitle: (chatRoomModel.lastMessage.toString()!="null") 
                                      ? Text(chatRoomModel.lastMessage.toString().trim(),maxLines: 2,style: TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.secondary),) 
                                      : Text("Say hi to your new friend!", 
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Theme.of(context).colorScheme.secondary,
                                        ),
                                      ),
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                        loading: () => CircularProgressIndicator(),
                        error: (err, stack) => Text("Error: $err"),
                      );
                    },
                  );
                },
              );
            },
            loading: () => Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text(err.toString())),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return SearchPage(userModel: userModel, firebaseUser: firebaseUser);
          }));
        },
        child: Icon(Icons.search),
      ),
    );
  }
}
