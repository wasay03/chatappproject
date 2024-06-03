import 'package:chatappproject/screens/SignUpPage.dart';
import 'package:chatappproject/screens/CompleteProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: SignUpPage(),
    );
  }

  testWidgets('SignUpPage has email, password and confirm password fields', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(TextField), findsNWidgets(3));
    expect(find.widgetWithText(TextField, 'Email Address'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Confirm Password'), findsOneWidget);
  });

  testWidgets('SignUpPage has sign up button', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Sign Up'), findsOneWidget);
  });

  testWidgets('SignUpPage has navigation to login page', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Already have an account?'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
  });

  testWidgets('Clicking Log In navigates back to the previous page', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();

    expect(find.byType(SignUpPage), findsNothing);
  });

  testWidgets('Clicking Sign Up shows AlertDialog on error', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.enterText(find.widgetWithText(TextField, 'Email Address'), 'test@example.com');
    await tester.enterText(find.widgetWithText(TextField, 'Password'), 'password123');
    await tester.enterText(find.widgetWithText(TextField, 'Confirm Password'), 'password1234'); // mismatch password

    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Sign Up Error'), findsOneWidget);
  });
}
