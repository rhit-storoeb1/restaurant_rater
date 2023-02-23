import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_model_utils.dart';

const String ReviewCollectionPath = "Reviews";
const String Review_authorUid = "authorUid";
const String Review_rating = "rating";
const String Review_comment = "comment";
const String Review_lastTouched = "lastTouched";
const String Review_restaurant = "restaurantName";

class Review {
  String? documentId;
  String authorUid;
  double rating;
  String comment;
  String restName;
  Timestamp lastTouched;

  Review(
      {this.documentId,
      required this.authorUid,
      required this.rating,
      required this.comment,
      required this.restName,
      required this.lastTouched});

  Review.from(DocumentSnapshot doc)
      : this(
            documentId: doc.id,
            authorUid:
                FirestoreModelUtils.getStringField(doc, Review_authorUid),
            rating: FirestoreModelUtils.getDoubleField(doc, Review_rating),
            comment: FirestoreModelUtils.getStringField(doc, Review_comment),
            restName:
                FirestoreModelUtils.getStringField(doc, Review_restaurant),
            lastTouched:
                FirestoreModelUtils.getTimestampField(doc, Review_lastTouched));

  Map<String, Object?> toMap() {
    return {
      Review_authorUid: authorUid,
      Review_lastTouched: lastTouched,
      Review_rating: rating,
      Review_comment: comment,
    };
  }

  @override
  String toString() {
    return "$documentId: User $authorUid rated this restaurant $rating/5 and said this about it: $comment";
  }
}
