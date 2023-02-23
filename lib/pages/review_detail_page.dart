import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restaurant_rater/managers/reviews_collection_manager.dart';

import '../managers/auth_manager.dart';
import '../managers/review_document_manager.dart';

class ReviewDetailPage extends StatefulWidget {
  final String documentId;
  const ReviewDetailPage(this.documentId, {super.key});

  @override
  State<ReviewDetailPage> createState() => _ReviewDetailPageState();
}

class _ReviewDetailPageState extends State<ReviewDetailPage> {
  StreamSubscription? reviewSubscription;

  @override
  void initState() {
    super.initState();

    reviewSubscription = ReviewDocumentManager.instance.startListening(
      widget.documentId,
      () {
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    ReviewDocumentManager.instance.stopListening(reviewSubscription);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool showEditDelete =
        ReviewDocumentManager.instance.latestReview != null &&
            AuthManager.instance.uid.isNotEmpty &&
            AuthManager.instance.uid ==
                ReviewDocumentManager.instance.latestReview!.authorUid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("RoseRestaurantRater"),
        actions: [
          Visibility(
            visible: showEditDelete,
            child: IconButton(
              onPressed: () {
                final justDeletedRating =
                    ReviewDocumentManager.instance.latestReview!.rating;
                final justDeletedComment =
                    ReviewDocumentManager.instance.latestReview!.comment;
                final justDeletedRestName =
                    ReviewDocumentManager.instance.latestReview!.restName;

                ReviewDocumentManager.instance.delete();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Review Deleted'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        ReviewsCollectionManager.instance.add(
                          comment: justDeletedComment,
                          rating: justDeletedRating,
                          restName: justDeletedRestName,
                        );
                      },
                    ),
                  ),
                );
                Navigator.pop(context);
              },
              icon: const Icon(Icons.delete),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            LabelledTextDisplay(
              title: "Restaurant:",
              content:
                  ReviewDocumentManager.instance.latestReview?.restName ?? "",
              iconData: Icons.fastfood,
            ),
            LabelledTextDisplay(
              title: "Rating:",
              content: ReviewDocumentManager.instance.latestReview?.rating
                      .toString() ??
                  "",
              iconData: Icons.star,
            ),
            LabelledTextDisplay(
              title: "Comment:",
              content:
                  ReviewDocumentManager.instance.latestReview?.comment ?? "",
              iconData: Icons.format_quote_outlined,
            ),
          ],
        ),
      ),
    );
  }
}

class LabelledTextDisplay extends StatelessWidget {
  final String title;
  final String content;
  final IconData iconData;

  const LabelledTextDisplay({
    super.key,
    required this.title,
    required this.content,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w800,
                fontFamily: "Caveat"),
          ),
          Card(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Icon(iconData),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Flexible(
                    child: Text(
                      content,
                      style: const TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
