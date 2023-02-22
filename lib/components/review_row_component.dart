//Will show data from Restaurant

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../models/restaurant.dart';
import '../models/review.dart';

class ReviewRowItem extends StatelessWidget {
  final Review r;

  const ReviewRowItem({required this.r, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
        child: Card(
          child: ListTile(
            leading: const Icon(Icons.star),
            title: Text(
              r.rating.toString(),
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              r.comment,
              //r.reviews[0].get().toString(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
