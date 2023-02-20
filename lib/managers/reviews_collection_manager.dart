//manage the list of ratings shown on a Restaurant ratings list page

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_rater/models/restaurant.dart';
import 'dart:async';
import '../models/review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth_manager.dart';

//this shouldn't be a singleton since we have multiple of these to deal with

class ReviewsCollectionManager{
  List<Review> latestReviews = [];
  late CollectionReference _ref;

  ReviewsCollectionManager(String restaurantDocumentId){
    _ref = FirebaseFirestore.instance.collection(RestaurantsCollectionPath)
      .doc(restaurantDocumentId).collection(ReviewCollectionPath);
  }

  //todo: there is no isFilteredForMine here. We could add different filters
  StreamSubscription startListening(Function() observer) {
    Query query = _ref.orderBy(Review_lastTouched, descending: true);
    return query.snapshots().listen((QuerySnapshot snapshot) {
      latestReviews = snapshot.docs.map((doc) => Review.from(doc)).toList();
      observer();
    });
  }

  void stopListening(StreamSubscription? subscription) {
    subscription?.cancel();
  }

  //add a new Review to the Restaurant
  Future<void> add({
    required int rating,
    required String comment
  }) {
    return _ref
      .add({
        Review_rating: rating,
        Review_comment: comment,
        Review_lastTouched: Timestamp.now(),
        Review_authorUid: AuthManager.instance.uid
      })
      .then((DocumentReference docRef) => {
        print("Review added!")
        //TODO: call the method to update the average rating of the restaurant here
      })
      .catchError((error) => print("Failed to add review: $error"));
  }

  //get all reviews for this restaurant
  Query<Review> get allReviewsQuery => _ref
    .orderBy(Review_lastTouched, descending: true)
    .withConverter<Review>(
      fromFirestore: (snapshot, _) => Review.from(snapshot),
      toFirestore: (review, _) => review.toMap(),
    );
  
  //note: no myReviewsQuery is needed for now
}