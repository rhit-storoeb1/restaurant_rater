import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutterfire_ui/firestore.dart';
import 'package:restaurant_rater/components/review_row_component.dart';
import 'package:restaurant_rater/models/review.dart';

import '../managers/restaurants_collection_manager.dart';
import '../managers/reviews_collection_manager.dart';

class ReviewList extends StatelessWidget {
  final Query<Review> query;
  const ReviewList({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.0,
      child: FirestoreListView<Review>(
        query: query,
        itemBuilder: (context, snapshot) {
          Review r = snapshot.data();
          return ReviewRowItem(
            r: r,
          );
        },
      ),
    );
  }
}
