
import 'package:chatappproject/models/ChatRoomModel.dart';
import 'package:chatappproject/models/MessageModel.dart';
import 'package:chatappproject/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final uuidProvider = Provider((ref) => Uuid());

final chatRoomProvider = StateNotifierProvider<ChatRoomNotifier, ChatRoomModel>((ref) {
  return ChatRoomNotifier();
});

class ChatRoomNotifier extends StateNotifier<ChatRoomModel> {
  ChatRoomNotifier() : super(ChatRoomModel());

  void updateLastMessage(String lastMessage) {
    state = state.copyWith(lastMessage: lastMessage);
  }
}

final messageControllerProvider = Provider((ref) => TextEditingController());

final messagesStreamProvider = StreamProvider.family<QuerySnapshot, String>((ref, chatroomid) {
  return FirebaseFirestore.instance.collection("chatrooms").doc(chatroomid).collection("messages").orderBy("createdon", descending: true).snapshots();
});

final sendMessageProvider = Provider((ref) {
  return SendMessage(ref);
});

class SendMessage {
  final ProviderRef ref;

  SendMessage(this.ref);

  void call(String msg, UserModel userModel, ChatRoomModel chatroom) async {
    if (msg.trim().isEmpty) return;

    final messageId = ref.read(uuidProvider).v1();
    final newMessage = MessageModel(
      messageid: messageId,
      sender: userModel.uid,
      createdon: DateTime.now(),
      text: msg.trim(),
      seen: false,
    );

    final chatroomRef = FirebaseFirestore.instance.collection("chatrooms").doc(chatroom.chatroomid);
    await chatroomRef.collection("messages").doc(messageId).set(newMessage.toMap());

    chatroom.lastMessage = msg;
    await chatroomRef.set(chatroom.toMap());

    ref.read(chatRoomProvider.notifier).updateLastMessage(msg);
  }
}
