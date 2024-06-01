
import 'package:chatappproject/models/ChatRoomModel.dart';
import 'package:chatappproject/models/MessageModel.dart';
import 'package:chatappproject/models/UserModel.dart';
import 'package:chatappproject/providers/chat_provider.dart';
import 'package:chatappproject/providers/home_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatRoomPage extends ConsumerWidget {
  final UserModel targetUser;
  final ChatRoomModel chatroom;
  final UserModel userModel;
  final User firebaseUser;

  const ChatRoomPage({Key? key, required this.targetUser, required this.chatroom, required this.userModel, required this.firebaseUser}) : super(key: key);
  
  Future<void> markMessagesAsSeen(WidgetRef ref) async {
    final firestore = ref.read(firebaseFirestoreProvider);
    final chatroomRef = firestore.collection('chatrooms').doc(chatroom.chatroomid);
    final messagesQuery = chatroomRef.collection('messages')
      .where('sender', isEqualTo: targetUser.uid)
      .where('seen', isEqualTo: false);
      
    final messagesSnapshot = await messagesQuery.get();
    
    final batch = firestore.batch();
    
    for (var doc in messagesSnapshot.docs) {
      batch.update(doc.reference, {'seen': true});
    }
    
    await batch.commit();
  }
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageController = ref.watch(messageControllerProvider);
    
    final sendMessage = ref.watch(sendMessageProvider);
    final messagesStream = ref.watch(messagesStreamProvider(chatroom.chatroomid as String));

    void sendMessageHandler() {
      sendMessage(messageController.text, userModel, chatroom);
      messageController.clear();
    }
    markMessagesAsSeen(ref);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              backgroundImage: NetworkImage(targetUser.profilepic.toString()),
            ),
            SizedBox(width: 10),
            Text(targetUser.fullname.toString()),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: messagesStream.when(
                  data: (dataSnapshot) {
                    return ListView.builder(
                      reverse: true,
                      itemCount: dataSnapshot.docs.length,
                      itemBuilder: (context, index) {
                        MessageModel currentMessage = MessageModel.fromMap(dataSnapshot.docs[index].data() as Map<String, dynamic>);
                        MessageModel lastSentMessage=MessageModel.fromMap(dataSnapshot.docs[0].data() as Map<String,dynamic>);
                        if(currentMessage.sender==userModel.uid){
                          lastSentMessage=currentMessage;
                        }

                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: (currentMessage.sender == userModel.uid) ? MainAxisAlignment.end : MainAxisAlignment.start,
                              children: [
                                Container(
                                  
                                  margin: EdgeInsets.symmetric(vertical: 2),
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: (currentMessage.sender == userModel.uid) ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Stack(
                                    children: [
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                                        ),
                                        child: Text(
                                          currentMessage.text.toString(),
                                          style: TextStyle(color: Colors.white,fontSize: 25),
                                          softWrap: true,
                                          overflow: TextOverflow.visible, 
                                        ),
                                        
                                      
                                       
                                      ),
                                      
                                    ],
                                  ),
                                
                                ),
                                
                               
                              ],
                              
                            ),
                          
                                         Row(
                                          mainAxisAlignment:(currentMessage.sender==userModel.uid)? MainAxisAlignment.end:MainAxisAlignment.start,
                                        children: [
                                          
                                          Text(TimeOfDay.fromDateTime(currentMessage.createdon!).format(context) ),
                                          Icon((currentMessage.sender==userModel.uid)?((lastSentMessage.seen!)? Icons.done_all:Icons.check):null,size: 20,color:(lastSentMessage.seen!)? Colors.blue:Colors.grey, ),
                                        ],
                                                                        ),
                          
                          ],
                        );
                      },
                    );
                  },
                  loading: () => Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text("An error occurred! Please check your internet connection.")),
                ),
              ),
            ),
            Container(
              color: Colors.grey[200],
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                children: [
                  Flexible(
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: TextField(
                        textInputAction: TextInputAction.go,
                        onSubmitted: (value){
                          sendMessageHandler();
                        },
                        controller: messageController,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: " Type a message ...",
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: sendMessageHandler,
                    icon: Icon(Icons.send_outlined, color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
