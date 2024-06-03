// import 'package:chatappproject/models/ChatRoomModel.dart';
// import 'package:chatappproject/models/UserModel.dart';
// import 'package:chatappproject/screens/ChatRoomPage.dart';
// import 'package:chatappproject/providers/chat_provider.dart';
// import 'package:chatappproject/providers/home_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';

// import 'CompleteProfile_test.dart';

// class MockUserModel extends Mock implements UserModel {}

// class MockChatRoomModel extends Mock implements ChatRoomModel {}

// void main() {
//   late MockUserModel mockUser;
//   late MockUserModel mockTargetUser;
//   late MockChatRoomModel mockChatRoom;
//   late ProviderContainer container;

//   setUp(() {
//     mockUser = MockUserModel();
//     mockTargetUser = MockUserModel();
//     mockChatRoom = MockChatRoomModel();

//     when(mockUser.uid).thenReturn('user123');
//     when(mockUser.profilepic).thenReturn('http://example.com/user_profilepic.jpg');
//     when(mockUser.fullname).thenReturn('Current User');
//     when(mockUser.email).thenReturn('currentuser@example.com');

//     when(mockTargetUser.uid).thenReturn('targetUser123');
//     when(mockTargetUser.profilepic).thenReturn('http://example.com/target_profilepic.jpg');
//     when(mockTargetUser.fullname).thenReturn('Target User');
//     when(mockTargetUser.email).thenReturn('targetuser@example.com');

//     when(mockChatRoom.chatroomid).thenReturn('chatroom123');

//     container = ProviderContainer(
//       overrides: [
//         messageControllerProvider.overrideWithValue(TextEditingController()),
//         messagesStreamProvider.overrideWithProvider((chatroomid) => StreamProvider.autoDispose.family(
//             (ref, String chatroomid) => Stream.value(MockQuerySnapshot()))),
//       ],
//     );
//   });

//   tearDown(() {
//     container.dispose();
//   });

//   Widget createWidgetUnderTest() {
//     return ProviderScope(
//       child: MaterialApp(
//         home: ChatRoomPage(
//           targetUser: mockTargetUser,
//           chatroom: mockChatRoom,
//           userModel: mockUser,
//           firebaseUser: MockUser(),
//         ),
//       ),
//     );
//   }

//   testWidgets('ChatRoomPage displays user information in AppBar', (WidgetTester tester) async {
//     await tester.pumpWidget(createWidgetUnderTest());

//     expect(find.byType(AppBar), findsOneWidget);
//     expect(find.byType(CircleAvatar), findsOneWidget);
//     expect(find.text('Target User'), findsOneWidget);
//   });

//   testWidgets('ChatRoomPage displays messages list', (WidgetTester tester) async {
//     await tester.pumpWidget(createWidgetUnderTest());

//     expect(find.byType(ListView), findsOneWidget);
//   });

//   testWidgets('ChatRoomPage displays TextField for composing messages', (WidgetTester tester) async {
//     await tester.pumpWidget(createWidgetUnderTest());

//     expect(find.byType(TextField), findsOneWidget);
//     expect(find.text(' Type a message ...'), findsOneWidget);
//   });

//   testWidgets('ChatRoomPage displays IconButton for sending messages', (WidgetTester tester) async {
//     await tester.pumpWidget(createWidgetUnderTest());

//     expect(find.byType(IconButton), findsOneWidget);
//     expect(find.byIcon(Icons.send_outlined), findsOneWidget);
//   });
// }
