

import 'package:chatappproject/models/UserModel.dart';
import 'package:chatappproject/providers/search_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/src/consumer.dart';


class searchService{
  Future<void> performSearch(String text,String useremail,ref) async {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("email", isEqualTo: text)
          .where("email", isNotEqualTo: useremail)
          .get();

      if (snapshot.docs.isNotEmpty) {
        List<UserModel> results = snapshot.docs.map((doc) {
          return UserModel.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();
        ref.read(searchResultsProvider.notifier).setSearchResults(results);
      } else {
        ref.read(searchResultsProvider.notifier).clearSearchResults();
      }
    }
}