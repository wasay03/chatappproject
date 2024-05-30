import 'package:chatappproject/models/ChatRoomModel.dart';
import 'package:chatappproject/models/UserModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

final searchControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});

final searchResultsProvider = StateNotifierProvider<SearchResultsNotifier, List<UserModel>>((ref) {
  return SearchResultsNotifier();
});

class SearchResultsNotifier extends StateNotifier<List<UserModel>> {
  SearchResultsNotifier() : super([]);

  void setSearchResults(List<UserModel> results) {
    state = results;
  }

  void clearSearchResults() {
    state = [];
  }
}

final chatRoomProvider = StateNotifierProvider<ChatRoomNotifier, ChatRoomModel?>((ref) {
  return ChatRoomNotifier();
});

class ChatRoomNotifier extends StateNotifier<ChatRoomModel?> {
  ChatRoomNotifier() : super(null);

  Future<ChatRoomModel?> getChatroomModel(UserModel currentUser, UserModel targetUser) async {
    ChatRoomModel? chatRoom;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${currentUser.uid}", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var docData = snapshot.docs[0].data() as Map<String, dynamic>;
      ChatRoomModel existingChatroom = ChatRoomModel.fromMap(docData);
      chatRoom = existingChatroom;
    } else {
      ChatRoomModel newChatroom = ChatRoomModel(
        chatroomid: DateTime.now().millisecondsSinceEpoch.toString(),
        participants: [currentUser.uid!, targetUser.uid!] as Map<String,dynamic> ,
      );

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatroom.chatroomid)
          .set(newChatroom.toMap());

      chatRoom = newChatroom;
    }

    state = chatRoom;
    return chatRoom;
  }
}
