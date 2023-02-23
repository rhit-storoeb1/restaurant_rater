import 'package:flutter/material.dart';

import '../models/review.dart';

class ReviewRowItem extends StatelessWidget {
  final Review r;
  final Function() onTap;
  final bool showRestName;

  const ReviewRowItem({
    required this.r,
    required this.onTap,
    required this.showRestName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
        child: Card(
          child: ListTile(
            leading: const Icon(Icons.star),
            title: Text(
              showRestName
                  ? '${r.restName} - ${r.rating}'
                  : r.rating.toString(),
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              r.comment,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
