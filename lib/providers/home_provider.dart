
import 'package:chatappproject/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final chatRoomsStreamProvider = StreamProvider.autoDispose.family<QuerySnapshot, String>((ref, userId) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return firestore.collection("chatrooms").where("participants.$userId", isEqualTo: true).snapshots();
});

final userModelProvider = FutureProvider.family<UserModel?, String>((ref, userId) async {
  final firestore = ref.watch(firebaseFirestoreProvider);
  DocumentSnapshot docSnap = await firestore.collection("users").doc(userId).get();

  if (docSnap.data() != null) {
    return UserModel.fromMap(docSnap.data() as Map<String, dynamic>);
  }
  return null;
});
