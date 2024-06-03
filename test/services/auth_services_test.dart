import 'package:chatappproject/models/UserModel.dart';
import 'package:chatappproject/services/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_services_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FirebaseAuth>(),
  MockSpec<UserCredential>(),
  MockSpec<User>(),
  MockSpec<GoogleSignIn>(),
  MockSpec<GoogleSignInAccount>(),
  MockSpec<GoogleSignInAuthentication>(),
  MockSpec<FirebaseFirestore>(),
  MockSpec<DocumentSnapshot>(),
  MockSpec<DocumentReference>(),
  MockSpec<CollectionReference>(),
])
void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late AuthenticationService authService;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  late MockGoogleSignIn mockGoogleSignIn;
  late MockGoogleSignInAccount mockGoogleSignInAccount;
  late MockGoogleSignInAuthentication mockGoogleSignInAuthentication;
  late MockFirebaseFirestore mockFirestore;
  late MockDocumentSnapshot mockDocumentSnapshot;
  late MockDocumentReference mockDocumentReference;
  late MockCollectionReference mockCollectionReference;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    authService = AuthenticationService(mockFirebaseAuth);
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    mockGoogleSignIn = MockGoogleSignIn();
    mockGoogleSignInAccount = MockGoogleSignInAccount();
    mockGoogleSignInAuthentication = MockGoogleSignInAuthentication();
    mockFirestore = MockFirebaseFirestore();
    mockDocumentSnapshot = MockDocumentSnapshot();
    mockDocumentReference = MockDocumentReference();
    mockCollectionReference = MockCollectionReference();
  });

  group('AuthenticationService', () {
    test('signInWithEmailAndPassword returns UserCredential', () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => mockUserCredential);

      final result = await authService.signInWithEmailAndPassword('test@example.com', 'password');

      expect(result, isA<UserCredential>());
      verify(mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password',
      )).called(1);
    });

    test('getUserModel returns UserModel', () async {
      when(mockUser.uid).thenReturn('testUid');
      when(mockDocumentSnapshot.data()).thenReturn({
        'uid': 'testUid',
        'email': 'test@example.com',
        'name': 'Test User',
        'photoUrl': 'http://test.com/photo.jpg',
      });
      when(mockFirestore.collection(any)).thenReturn(mockCollectionReference as CollectionReference<Map<String, dynamic>>);
      when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
      when(mockDocumentReference.get()).thenAnswer((_) async => mockDocumentSnapshot);

      final userModel = await authService.getUserModel(mockUser);

      expect(userModel, isA<UserModel>());
      expect(userModel.uid, 'testUid');
    });

    test('signInWithGoogle returns UserCredential', () async {
      when(mockGoogleSignIn.signIn()).thenAnswer((_) async => mockGoogleSignInAccount);
      when(mockGoogleSignInAccount.authentication).thenAnswer((_) async => mockGoogleSignInAuthentication);
      when(mockGoogleSignInAuthentication.idToken).thenReturn('testIdToken');
      when(mockGoogleSignInAuthentication.accessToken).thenReturn('testAccessToken');
      when(mockFirebaseAuth.signInWithCredential(any)).thenAnswer((_) async => mockUserCredential);
      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('testUid');

      // Mock Firestore references with explicit casting
      final usersCollectionReference = mockCollectionReference as MockCollectionReference<Map<String, dynamic>>;
      final userDocumentReference = mockDocumentReference as MockDocumentReference<Map<String, dynamic>>;
      final userDocumentSnapshot = mockDocumentSnapshot as MockDocumentSnapshot<Map<String, dynamic>>;

      when(mockFirestore.collection('users')).thenReturn(usersCollectionReference);
      when(usersCollectionReference.doc('testUid')).thenReturn(userDocumentReference);
      when(userDocumentReference.get()).thenAnswer((_) async => userDocumentSnapshot);
      when(userDocumentSnapshot.exists).thenReturn(false);
      //when(userDocumentReference.set(any<Map<String, dynamic>>())).thenAnswer((_) async => Future.value());

      final result = await authService.signInWithGoogle();

      expect(result, isA<UserCredential>());
    });

    test('signOut calls FirebaseAuth.signOut', () async {
      await authService.signOut();

      verify(mockFirebaseAuth.signOut()).called(1);
    });
  });
}
