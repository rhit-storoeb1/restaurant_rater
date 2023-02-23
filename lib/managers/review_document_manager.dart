import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_rater/managers/restaurant_document_manager.dart';
import 'package:restaurant_rater/managers/reviews_collection_manager.dart';

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

  Future<void> delete() {
    return _ref.doc(latestReview?.documentId!).delete().then((e) {
      var reviewDocs = ReviewsCollectionManager.instance.reviewsForRestaurant(
          RestaurantDocumentManager.instance.latestRestaurant?.name);

      reviewDocs.get().then((value) {
        var rating = 0.0;
        var reviews = value.docs;
        for (var r in reviews) {
          rating += r.data().rating;
        }
        rating = rating / reviews.length;

        RestaurantDocumentManager.instance.update(
            name: RestaurantDocumentManager.instance.latestRestaurant!.name,
            address:
                RestaurantDocumentManager.instance.latestRestaurant!.address,
            category: RestaurantDocumentManager.instance.latestRestaurant!.category,
            averageRating: double.parse(rating.toStringAsFixed(1)));
      }, onError: (e) => print("error creating"));
    });
  }
}
