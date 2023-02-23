import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/restaurant.dart';
import '../models/review.dart';

class ReviewDocumentManager {
  Review? latestReview;
  final CollectionReference _ref;

  static final ReviewDocumentManager instance =
      ReviewDocumentManager._privateConstructor();

  ReviewDocumentManager._privateConstructor()
      : _ref = FirebaseFirestore.instance.collection(ReviewCollectionPath);

  StreamSubscription startListening(String documentId, Function() observer) {
    return _ref
        .doc(documentId)
        .snapshots()
        .listen((DocumentSnapshot docSnapshot) {
      latestReview = Review.from(docSnapshot);
      observer();
    });
  }

  void stopListening(StreamSubscription? subscription) =>
      subscription?.cancel();

  // void update({
  //   required String name,
  //   required String address,
  //   required double averageRating,
  // }) {
  //   if (latestReview == null) {
  //     return;
  //   }
  //   _ref.doc(latestReview!.documentId!).update({
  //     Restaurants_name: name,
  //     Restaurants_address: address,
  //     Restaurants_averageRating: averageRating,
  //   }).catchError((error) => print("Failed to update the movie quote: $error"));
  // }

  Future<void> delete() {
    return _ref.doc(latestReview?.documentId!).delete();
  }
}
