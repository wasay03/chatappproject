import 'package:chatappproject/models/ChatRoomModel.dart';
import 'package:chatappproject/models/UserModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// User provider
final userProvider = StateNotifierProvider<UserNotifier, List<UserModel>>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<List<UserModel>> {
  UserNotifier() : super([]);

  void setUser(UserModel user) {
    state = [user];
  }

  void clearUser() {
    state = [];
  }
}

// Chat room provider
final chatRoomProvider = StateNotifierProvider<ChatRoomNotifier, List<ChatRoomModel>>((ref) {
  return ChatRoomNotifier();
});

class ChatRoomNotifier extends StateNotifier<List<ChatRoomModel>> {
  ChatRoomNotifier() : super([]);

  void setChatRoom(ChatRoomModel chatRoom) {
    state = [chatRoom];
  }

  void clearChatRoom() {
    state = [];
  }
}
