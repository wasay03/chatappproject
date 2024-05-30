import 'dart:developer';
import 'package:chatappproject/models/ChatRoomModel.dart';
import 'package:chatappproject/models/UserModel.dart';
import 'package:chatappproject/providers/search_provider.dart';
import 'package:chatappproject/screens/ChatRoomPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPage extends ConsumerWidget {
  final UserModel userModel;
  final User firebaseUser;

  const SearchPage({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = ref.watch(searchControllerProvider);
    final searchResults = ref.watch(searchResultsProvider);
    final chatRoomNotifier = ref.watch(chatRoomProvider.notifier);

    void performSearch() async {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("email", isEqualTo: searchController.text)
          .where("email", isNotEqualTo: userModel.email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        List<UserModel> results = snapshot.docs.map((doc) {
          return UserModel.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();
        ref.read(searchResultsProvider.notifier).setSearchResults(results);
      } else {
        ref.read(searchResultsProvider.notifier).clearSearchResults();
      }
    }

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
              CupertinoButton(
                onPressed: performSearch,
                color: Theme.of(context).colorScheme.secondary,
                child: Text("Search"),
              ),
              SizedBox(height: 20),
              if (searchResults.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      UserModel searchedUser = searchResults[index];

                      return ListTile(
                        onTap: () async {
                          ChatRoomModel? chatroomModel = await chatRoomNotifier.getChatroomModel(userModel, searchedUser);
                          if (chatroomModel != null) {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return ChatRoomPage(
                                  targetUser: searchedUser,
                                  userModel: userModel,
                                  firebaseUser: firebaseUser,
                                  chatroom: chatroomModel,
                                );
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
                    },
                  ),
                ),
              if (searchResults.isEmpty)
                Text("No results found!"),
            ],
          ),
        ),
      ),
    );
  }
}
