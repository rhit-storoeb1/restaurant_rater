//manage the list of ratings shown on a Restaurant ratings list page

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_rater/managers/restaurant_document_manager.dart';
import 'package:restaurant_rater/models/restaurant.dart';
import 'dart:async';
import '../models/review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth_manager.dart';

//this shouldn't be a singleton since we have multiple of these to deal with

class ReviewsCollectionManager {
  List<Review> latestReviews = [];
  final CollectionReference _ref;

  // ReviewsCollectionManager(String restaurantDocumentId) {
  //   _ref = FirebaseFirestore.instance
  //       .collection(RestaurantsCollectionPath)
  //       .doc(restaurantDocumentId)
  //       .collection(ReviewCollectionPath);
  // }

  ReviewsCollectionManager._privateConstructor()
      : _ref = FirebaseFirestore.instance.collection(ReviewCollectionPath);

  static final ReviewsCollectionManager instance =
      ReviewsCollectionManager._privateConstructor();

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
  Future<void> add(
      {required double rating,
      required String comment,
      required String restName}) {
    return _ref.add({
      Review_rating: rating,
      Review_comment: comment,
      Review_restaurant: restName,
      Review_lastTouched: Timestamp.now(),
      Review_authorUid: AuthManager.instance.uid
    }).then((DocumentReference docRef) {
      print("Review added!");
      var reviewDocs = ReviewsCollectionManager.instance.reviewsForRestaurant(
          RestaurantDocumentManager.instance.latestRestaurant?.name);

      reviewDocs.get().then((value) {
        var rating = 0.0;
        ReviewsCollectionManager.instance.startListening(() {
          var reviews = ReviewsCollectionManager.instance.latestReviews;
          print(reviews.length);
          for (var r in reviews) {
            rating += r.rating;
          }
          rating = rating / reviews.length;

          RestaurantDocumentManager.instance.update(
              name: RestaurantDocumentManager.instance.latestRestaurant!.name,
              address:
                  RestaurantDocumentManager.instance.latestRestaurant!.address,
              averageRating: double.parse(rating.toStringAsFixed(1)));
        });
      }, onError: (e) => print("error creating"));
    }).catchError((error) => print("Failed to add review: $error"));
  }

  //get all reviews for this restaurant
  Query<Review> get allReviewsQuery => _ref
          // .orderBy(Review_lastTouched, descending: true)
          .withConverter<Review>(
        fromFirestore: (snapshot, _) => Review.from(snapshot),
        toFirestore: (review, _) => review.toMap(),
      );

  Query<Review> reviewsForRestaurant(restName) {
    return allReviewsQuery.where(Review_restaurant, isEqualTo: restName);
  }

  Query<Review> reviewsForUser() {
    return allReviewsQuery.where(Review_authorUid,
        isEqualTo: AuthManager.instance.uid);
  }

  //note: no myReviewsQuery is needed for now
}
