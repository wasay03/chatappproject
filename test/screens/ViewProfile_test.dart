// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';

// import 'package:chatappproject/models/ChatRoomModel.dart';
// import 'package:chatappproject/models/UserModel.dart';
// import 'package:chatappproject/screens/ViewProfile.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:http/http.dart' as http;
// import 'package:http/testing.dart';

// class MockUserModel extends Mock implements UserModel {}

// class MockChatRoomModel extends Mock implements ChatRoomModel {}

// // Mock HTTP Overrides
// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return MockHttpClient();
//   }
// }

// class MockHttpClient extends Mock implements HttpClient {
//   @override
//   Future<HttpClientRequest> getUrl(Uri url) async {
//     return MockHttpClientRequest();
//   }
// }

// class MockHttpClientRequest extends Mock implements HttpClientRequest {
//   @override
//   Future<HttpClientResponse> close() async {
//     return MockHttpClientResponse();
//   }
// }

// class MockHttpClientResponse extends Mock implements HttpClientResponse {
//   @override
//   int get statusCode => 200;

//   @override
//   Stream<List<int>> transform<T>(StreamTransformer<List<int>, T> streamTransformer) {
//     final data = utf8.encode('{"id": 1, "name": "test"}');
//     return Stream<List<int>>.fromIterable([data]).transform(streamTransformer as StreamTransformer<List<int>, List<int>>);
//   }

//   @override
//   HttpClientResponseCompressionState get compressionState => HttpClientResponseCompressionState.notCompressed;
// }

// void main() {
//   late MockUserModel mockUser;
//   late MockChatRoomModel mockChatRoom;

//   setUp(() {
//     mockUser = MockUserModel();
//     mockChatRoom = MockChatRoomModel();

//     when(mockUser.profilepic).thenReturn('http://example.com/profilepic.jpg');
//     when(mockUser.fullname).thenReturn('Test User');
//     when(mockUser.email).thenReturn('test@example.com');

//     HttpOverrides.global = MyHttpOverrides();
//   });

//   tearDown(() {
//     HttpOverrides.global = null;
//   });

//   Widget createWidgetUnderTest() {
//     return ProviderScope(
//       child: MaterialApp(
//         home: ViewProfile(
//           user: mockUser,
//           chatroom: mockChatRoom,
//         ),
//       ),
//     );
//   }

//   testWidgets('ViewProfile displays user information', (WidgetTester tester) async {
//     await tester.pumpWidget(createWidgetUnderTest());

//     expect(find.byType(CircleAvatar), findsOneWidget);
//     expect(find.byType(Text), findsNWidgets(2));
//     expect(find.text('Test User'), findsOneWidget);
//     expect(find.text('test@example.com'), findsOneWidget);
//   });

//   testWidgets('ViewProfile has AppBar with PopupMenuButton', (WidgetTester tester) async {
//     await tester.pumpWidget(createWidgetUnderTest());

//     expect(find.byType(AppBar), findsOneWidget);
//     expect(find.byType(PopupMenuButton<int>), findsOneWidget);
//   });

//   testWidgets('PopupMenuButton has Delete Conversation item', (WidgetTester tester) async {
//     await tester.pumpWidget(createWidgetUnderTest());

//     await tester.tap(find.byType(PopupMenuButton<int>));
//     await tester.pumpAndSettle();

//     expect(find.text('Delete Conversation'), findsOneWidget);
//   });

//   testWidgets('Delete Conversation item triggers handleClick callback', (WidgetTester tester) async {
//     await tester.pumpWidget(createWidgetUnderTest());

//     await tester.tap(find.byType(PopupMenuButton<int>));
//     await tester.pumpAndSettle();

//     await tester.tap(find.text('Delete Conversation'));
//     await tester.pump();

//     // Here you can add any additional verification if handleClick does any state changes or calls any methods.
//     // Since handleClick does nothing in the provided code, we simply check that the menu item is present.
//     expect(find.text('Delete Conversation'), findsOneWidget);
//   });
// }
