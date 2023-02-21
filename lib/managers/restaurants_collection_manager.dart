//manage the list of restaurants. Should be fairly boilerplate

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_rater/managers/reviews_collection_manager.dart';
import '../models/restaurant.dart';

class RestaurantsCollectionManager {
  List<Restaurant> restaurants = [];
  final CollectionReference _ref;

  static final RestaurantsCollectionManager instance =
      RestaurantsCollectionManager._privateConstructor();

  RestaurantsCollectionManager._privateConstructor()
      : _ref = FirebaseFirestore.instance.collection(RestaurantsCollectionPath);

  //since we don't have a lastTouched for restaurants, sort by name
  //we would sort by other things if wanted
  StreamSubscription startListening(Function() observer, {bool isFilteredForMine = false}) {
    Query query = _ref.orderBy(Restaurants_name, descending: true);
    return query.snapshots().listen((QuerySnapshot querySnapshot) {
      restaurants =
          querySnapshot.docs.map((doc) => Restaurant.from(doc)).toList();
      observer();
    });
  }

  void stopListening(StreamSubscription? subscription) {
    subscription?.cancel();
  }

  Future<void> add({
    required String name,
    required String address,
    required String category,
  }) {
    return _ref
        .add({
          Restaurants_name: name,
          Restaurants_address: address,
          Restaurants_category: category,
          Restaurants_reviewsList: [],
          Restaurants_averageRating: 0.0,
        })
        .then((DocumentReference docRef) =>
            print("Restaurant added with id ${docRef.id}"))
        .catchError((error) => print("Failed to add movie quote: $error"));
  }

  //sort restaurants by name
  Query<Restaurant> get allRestaurants => _ref
      .orderBy(Restaurants_name, descending: true)
      .withConverter<Restaurant>(
        fromFirestore: (snapshot, _) => Restaurant.from(snapshot),
        toFirestore: (restaurant, _) => restaurant.toMap(),
      );

  //query to get all restaurants from a certain category. still sorts by name
  Query<Restaurant> allRestaurantsFromCategory(String category) {
    return allRestaurants
      .where(Restaurants_category, isEqualTo: category);
  }

  //TODO: write method that recalculates the average rating of a restaurant
  //This will get called when the ReviewsCollectionManager adds a new Review

  //TODO: write query to sort all by rating (will require getting the average rating from all reviews)
  //We will need to make sure that whenever 
}
