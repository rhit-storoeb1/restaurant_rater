//Restaurant Model
// - Name
// - Restaurant Category (static list to choose from)
// - Address
//    - Distance from Rose (? - minutes and/or miles)
//    - If this is too hard we could just generate a link to google maps that shows directions from Rose to the restaurant
// - average rating out of 5 stars
// - Link to list of ratings

// I think the simplest action is we let users add a restaurant if it doesn't have have reviews yet
// and we trust the users to write accurate information and don't handle edit/delete.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_rater/models/review.dart';
import 'firestore_model_utils.dart';

const String RestaurantsCollectionPath = "Restaurants";
const String Restaurants_name = "name";
const String Restaurants_address = "address";
const String Restaurants_category = "category";
const String Restaurants_reviewsList = "reviews";
const String Restaurants_averageRating = "averageRating";

class Restaurant {
  String? documentId;
  String name;
  String address;
  String category;
  // List<Review> reviews;
  List reviews;
  double averageRating;
  //doesn't need lastTouched, authorUid

  Restaurant({
    this.documentId,
    required this.name,
    required this.address,
    required this.category,
    required this.reviews,
    required this.averageRating,
  });

  Restaurant.from(DocumentSnapshot doc)
      : this(
          documentId: doc.id,
          name: FirestoreModelUtils.getStringField(doc, Restaurants_name),
          address: FirestoreModelUtils.getStringField(doc, Restaurants_address),
          category:
              FirestoreModelUtils.getStringField(doc, Restaurants_category),
          reviews:
              FirestoreModelUtils.getArrayField(doc, Restaurants_reviewsList),
          averageRating: FirestoreModelUtils.getDoubleField(
              doc, Restaurants_averageRating),
        );

  Map<String, Object?> toMap() {
    return {
      Restaurants_name: name,
      Restaurants_address: address,
      Restaurants_category: category,
      Restaurants_reviewsList: reviews,
      Restaurants_averageRating: averageRating,
    };
  }

  @override
  String toString() {
    return "$documentId: $name at $address - $category - has average rating $averageRating";
  }
}
