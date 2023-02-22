import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/restaurant.dart';

class RestaurantDocumentManager {
  Restaurant? latestRestaurant;
  final CollectionReference _ref;

  static final RestaurantDocumentManager instance =
      RestaurantDocumentManager._privateConstructor();

  RestaurantDocumentManager._privateConstructor()
      : _ref = FirebaseFirestore.instance.collection(RestaurantsCollectionPath);

  StreamSubscription startListening(String documentId, Function() observer) {
    return _ref
        .doc(documentId)
        .snapshots()
        .listen((DocumentSnapshot docSnapshot) {
      latestRestaurant = Restaurant.from(docSnapshot);
      observer();
    });
  }

  void stopListening(StreamSubscription? subscription) =>
      subscription?.cancel();

  void update({
    required String name,
    required String address,
    required double averageRating,
  }) {
    if (latestRestaurant == null) {
      return;
    }
    _ref.doc(latestRestaurant!.documentId!).update({
      Restaurants_name: name,
      Restaurants_address: address,
      Restaurants_averageRating: averageRating,
    }).catchError((error) => print("Failed to update the movie quote: $error"));
  }

  Future<void> delete() {
    return _ref.doc(latestRestaurant?.documentId!).delete();
  }
}
