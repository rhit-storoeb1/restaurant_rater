import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_model_utils.dart';

const String RestaurantsCollectionPath = "Restaurants";
const String Restaurants_name = "name";
const String Restaurants_address = "address";
const String Restaurants_category = "category";
const String Restaurants_averageRating = "averageRating";

class Restaurant {
  String? documentId;
  String name;
  String address;
  String category;
  double averageRating;

  Restaurant({
    this.documentId,
    required this.name,
    required this.address,
    required this.category,
    required this.averageRating,
  });

  Restaurant.from(DocumentSnapshot doc)
      : this(
          documentId: doc.id,
          name: FirestoreModelUtils.getStringField(doc, Restaurants_name),
          address: FirestoreModelUtils.getStringField(doc, Restaurants_address),
          category:
              FirestoreModelUtils.getStringField(doc, Restaurants_category),
          averageRating: FirestoreModelUtils.getDoubleField(
              doc, Restaurants_averageRating),
        );

  Map<String, Object?> toMap() {
    return {
      Restaurants_name: name,
      Restaurants_address: address,
      Restaurants_category: category,
      Restaurants_averageRating: averageRating,
    };
  }

  @override
  String toString() {
    return "$documentId: $name at $address - $category - has average rating $averageRating";
  }
}
