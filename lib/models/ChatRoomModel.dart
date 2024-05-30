class ChatRoomModel {
  String? chatroomid;
  String? lastMessage;
  Map<String, bool>? participants;

  ChatRoomModel({this.chatroomid, this.lastMessage, this.participants});

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatroomid = map['chatroomid'];
    lastMessage = map['lastMessage'];
    participants = Map<String, bool>.from(map['participants']);
  }

  Map<String, dynamic> toMap() {
    return {
      'chatroomid': chatroomid,
      'lastMessage': lastMessage,
      'participants': participants,
    };
  }
}
