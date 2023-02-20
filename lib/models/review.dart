//Rating model
// - author
// - rating (out of 5 stars)
//    - if we avoid decimals we could use "star buttons" instead of a raw number input
// - comment
// - date published / lastTouched
//    - editable/deletable by the original author

import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_model_utils.dart';

const String ReviewCollectionPath = "reviews"; //not sure what goes here yet
const String Review_authorUid = "authorUid";
const String Review_rating = "rating";
const String Review_comment = "comment";
const String Review_lastTouched = "lastTouched";

class Review{
  String? documentId;
  String authorUid;
  int rating;
  String comment;
  Timestamp lastTouched;

  Review({
    this.documentId,
    required this.authorUid,
    required this.rating,
    required this.comment,
    required this.lastTouched
  });

  Review.from(DocumentSnapshot doc)
    : this(
        documentId: doc.id,
        authorUid: FirestoreModelUtils.getStringField(doc, Review_authorUid),
        rating: FirestoreModelUtils.getIntField(doc, Review_rating),
        comment: FirestoreModelUtils.getStringField(doc, Review_comment),
        lastTouched: FirestoreModelUtils.getTimestampField(doc, Review_lastTouched)
    );

  Map<String, Object?> toMap(){
    return {
      Review_authorUid: authorUid,
      Review_lastTouched: lastTouched,
      Review_rating: rating,
      Review_comment: comment,
    };
  }

  @override
  String toString(){
    return "$documentId: User $authorUid rated this restaurant $rating/5 and said this about it: $comment";
  }

}