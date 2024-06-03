import 'package:chatappproject/models/ChatRoomModel.dart';
import 'package:chatappproject/models/UserModel.dart';
import 'package:chatappproject/providers/chat_provider.dart';
import 'package:chatappproject/screens/HomePage.dart';
import 'package:chatappproject/screens/LoginPage.dart';
import 'package:chatappproject/screens/SearchPage.dart';
import 'package:chatappproject/screens/EditProfile.dart';
import 'package:chatappproject/providers/home_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mock classes
class MockUser extends Mock implements User {}
class MockUserModel extends Mock implements UserModel {}
class MockChatRoomModel extends Mock implements ChatRoomModel {}

void main() {
  late MockUser mockUser;
  late MockUserModel mockUserModel;
  late MockChatRoomModel mockChatRoomModel;

  setUp(() {
    mockUser = MockUser();
    mockUserModel = MockUserModel();
    mockChatRoomModel = MockChatRoomModel();
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      child: MaterialApp(
        home: HomePage(
          userModel: mockUserModel,
          firebaseUser: mockUser,
        ),
      ),
    );
  }

  testWidgets('HomePage has AppBar, ListView, and FloatingActionButton', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('HomePage navigates to SearchPage when FloatingActionButton is pressed', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.byType(FloatingActionButton));
    //await tester.pumpAndSettle();

    expect(find.byType(SearchPage), findsOneWidget);
  });

  testWidgets('HomePage navigates to EditProfile when edit icon is pressed', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.byIcon(Icons.mode_edit_outline_outlined));
    await tester.pumpAndSettle();

    // Expecting navigation to EditProfile page
    expect(find.byType(EditProfile), findsOneWidget);
  });

  testWidgets('HomePage signs out and navigates to LoginPage when logout icon is pressed', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.byIcon(Icons.exit_to_app));
    await tester.pumpAndSettle();

    // Expecting navigation to LoginPage
    expect(find.byType(LoginPage), findsOneWidget);
  });

  // testWidgets('HomePage shows chat rooms list', (WidgetTester tester) async {
  //   await tester.pumpWidget(
  //     ProviderScope(
  //       overrides: [
  //         chatRoomProvider.overrideWithProvider(StateNotifierProvider<ChatRoomNotifier, List<ChatRoomModel>>((ref) {
  //           return ChatRoomNotifier()..setChatRoom(mockChatRoomModel);
  //         })),
  //       ],
  //       child: MaterialApp(
  //         home: HomePage(
  //           userModel: mockUserModel,
  //           firebaseUser: mockUser,
  //         ),
  //       ),
  //     ),
  //   );

  //   await tester.pump(); // Trigger the stream

  //   expect(find.byType(ListTile), findsWidgets);
  // });
}
