import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_rater/components/review_list_componenet.dart';
import 'package:restaurant_rater/managers/reviews_collection_manager.dart';

import '../managers/auth_manager.dart';
import '../managers/restaurant_document_manager.dart';
import '../managers/restaurants_collection_manager.dart';
import '../models/review.dart';

class RestaurantDetailPage extends StatefulWidget {
  final String documentId;
  const RestaurantDetailPage(this.documentId, {super.key});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  final ratingTextController = TextEditingController();
  final commentTextController = TextEditingController();

  StreamSubscription? movieQuoteSubscription;

  @override
  void initState() {
    super.initState();

    movieQuoteSubscription = RestaurantDocumentManager.instance.startListening(
      widget.documentId,
      () {
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    ratingTextController.dispose();
    commentTextController.dispose();
    RestaurantDocumentManager.instance.stopListening(movieQuoteSubscription);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final bool showEditDelete =
    //     RestaurantDocumentManager.instance.latestMovieQuote != null &&
    //         AuthManager.instance.uid.isNotEmpty &&
    //         AuthManager.instance.uid ==
    //             MovieQuoteDocumentManager.instance.latestMovieQuote!.authorUid;
    final bool showEditDelete = false;

    return Scaffold(
      appBar: AppBar(
        title: const Text("RoseRestaurantRater"),
        actions: [
          Visibility(
            visible: showEditDelete,
            child: IconButton(
              onPressed: () {
                final justDeletedQuote =
                    RestaurantDocumentManager.instance.latestRestaurant!.name;
                final justDeletedMovie = RestaurantDocumentManager
                    .instance.latestRestaurant!.address;

                RestaurantDocumentManager.instance.delete();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Quote Deleted'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        // RestaurantsCollectionManager.instance.add(
                        //   quote: justDeletedQuote,
                        //   movie: justDeletedMovie,
                        // );
                      },
                    ),
                  ),
                );
                Navigator.pop(context);
              },
              icon: const Icon(Icons.delete),
            ),
          ),
          // const SizedBox(
          //   width: 40.0,
          // ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: Container(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            LabelledTextDisplay(
              title: "Name:",
              content:
                  RestaurantDocumentManager.instance.latestRestaurant?.name ??
                      "",
              iconData: Icons.format_quote_outlined,
            ),
            LabelledTextDisplay(
              title: "Address:",
              content: RestaurantDocumentManager
                      .instance.latestRestaurant?.address ??
                  "",
              iconData: Icons.home,
            ),
            LabelledTextDisplay(
              title: "Category:",
              content: RestaurantDocumentManager
                      .instance.latestRestaurant?.category ??
                  "",
              iconData: Icons.fastfood,
            ),
            LabelledTextDisplay(
              title: "Average Rating:",
              content: RestaurantDocumentManager
                      .instance.latestRestaurant?.averageRating
                      .toString() ??
                  "",
              iconData: Icons.star,
            ),
            const Text(
              "Reviews",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w800,
                  fontFamily: "Caveat"),
            ),
            ReviewList(
                restName:
                    RestaurantDocumentManager.instance.latestRestaurant?.name ??
                        ""),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCreateReviewDialog(context);
        },
        tooltip: 'Create',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showCreateReviewDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create a Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
                child: TextFormField(
                  controller: ratingTextController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter the rating',
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
                child: TextFormField(
                  controller: commentTextController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter the comment',
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Create'),
              onPressed: () {
                setState(() {
                  ReviewsCollectionManager.instance.add(
                      rating: double.parse(ratingTextController.text),
                      comment: commentTextController.text,
                      restName: RestaurantDocumentManager
                              .instance.latestRestaurant?.name ??
                          "");

                  var reviewDocs = ReviewsCollectionManager.instance
                      .reviewsForRestaurant(RestaurantDocumentManager
                          .instance.latestRestaurant?.name);

                  reviewDocs.get().then((value) {
                    var rating = 0.0;
                    ReviewsCollectionManager.instance.startListening(() {
                      var reviews =
                          ReviewsCollectionManager.instance.latestReviews;
                      print(reviews.length);
                      for (var r in reviews) {
                        rating += r.rating;
                      }
                      rating = rating / reviews.length;

                      RestaurantDocumentManager.instance.update(
                          name: RestaurantDocumentManager
                              .instance.latestRestaurant!.name,
                          address: RestaurantDocumentManager
                              .instance.latestRestaurant!.address,
                          averageRating:
                              double.parse(rating.toStringAsFixed(1)));
                    });
                  }, onError: (e) => print("error creating"));

                  ratingTextController.text = "";
                  commentTextController.text = "";
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w800,
                fontFamily: "Caveat"),
          ),
          Card(
            child: Container(
              padding: const EdgeInsets.all(5.0),
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
                        // fontWeight: FontWeight.w600,
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
