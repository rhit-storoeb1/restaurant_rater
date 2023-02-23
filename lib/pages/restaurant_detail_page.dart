import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_rater/components/review_list_component.dart';
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

  final nameTextController = TextEditingController();
  final addressTextController = TextEditingController();
  final categoryTextController = TextEditingController();

  bool ratingInputError = false;

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
    final bool showEditRestaurant =
      RestaurantDocumentManager.instance.latestRestaurant != null &&
      AuthManager.instance.uid.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text("RoseRestaurantRater"),
        actions: [
          Visibility(
            visible: showEditRestaurant,
            child: IconButton(
              onPressed: () {
                //todo: edit restaurant
                showEditRestaurantDialog(context);
              },
              icon: const Icon(Icons.edit),
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
              query: ReviewsCollectionManager.instance.reviewsForRestaurant(
                  RestaurantDocumentManager.instance.latestRestaurant?.name ??
                      ""),
            ),
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
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Rating must be between 1 and 5",
                  style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic, fontSize: 10)
                ),
              )
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
                double attemptedRating = double.parse(ratingTextController.text);
                ratingInputError = attemptedRating>5 && attemptedRating>1;
                if(!ratingInputError){
                  setState(() {
                    ratingInputError=ratingInputError;
                    ReviewsCollectionManager.instance.add(
                        rating: attemptedRating,
                        comment: commentTextController.text,
                        restName: RestaurantDocumentManager
                                .instance.latestRestaurant?.name ??
                            "");
                    ratingTextController.text = "";
                    commentTextController.text = "";
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showEditRestaurantDialog(BuildContext context) {
    nameTextController.text =
        RestaurantDocumentManager.instance.latestRestaurant?.name ?? "";
    addressTextController.text =
        RestaurantDocumentManager.instance.latestRestaurant?.address ?? "";
    categoryTextController.text =
        RestaurantDocumentManager.instance.latestRestaurant?.category ?? "";

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit this Restaurant'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
                child: TextFormField(
                  controller: nameTextController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Name:',
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
                child: TextFormField(
                  controller: addressTextController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Address:',
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
                child: TextFormField(
                  controller: categoryTextController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Category:',
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
              child: const Text('Update'),
              onPressed: () {
                setState(() {
                  RestaurantDocumentManager.instance.update(
                    name: nameTextController.text,
                    address: addressTextController.text,
                    category: categoryTextController.text,
                    averageRating: RestaurantDocumentManager.instance.latestRestaurant!.averageRating
                  );
                  nameTextController.text = "";
                  addressTextController.text = "";
                  categoryTextController.text = "";

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
