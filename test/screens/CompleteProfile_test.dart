import 'package:chatappproject/models/UserModel.dart';
import 'package:chatappproject/screens/CompleteProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUser extends Mock implements User {}
class MockUserModel extends Mock implements UserModel {}

void main() {
  late MockUser mockUser;
  late MockUserModel mockUserModel;

  setUp(() {
    mockUser = MockUser();
    mockUserModel = MockUserModel();
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      child: MaterialApp(
        home: CompleteProfile(
          userModel: mockUserModel,
          firebaseUser: mockUser,
        ),
      ),
    );
  }

  testWidgets('CompleteProfile has profile picture, full name input and submit button', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Full Name'), findsOneWidget);
    expect(find.text('Submit'), findsOneWidget);
  });

  testWidgets('CompleteProfile shows photo options on profile picture tap', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.byType(CircleAvatar));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Upload Profile Picture'), findsOneWidget);
    expect(find.text('Select from Gallery'), findsOneWidget);
    expect(find.text('Take a photo'), findsOneWidget);
  });

  testWidgets('CompleteProfile updates full name', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.enterText(find.widgetWithText(TextField, 'Full Name'), 'Test User');
    await tester.pump();

    final textField = find.widgetWithText(TextField, 'Full Name').evaluate().first.widget as TextField;
    expect(textField.controller!.text, 'Test User');
  });

  testWidgets('CompleteProfile shows alert on incomplete data', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.text('Submit'));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Incomplete Data'), findsOneWidget);
    expect(find.text('Please fill all the fields and upload a profile picture'), findsOneWidget);
  });
}
