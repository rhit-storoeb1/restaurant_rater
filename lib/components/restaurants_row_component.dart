//Will show data from Restaurant

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../models/restaurant.dart';

class RestaurantRowItem extends StatelessWidget {
  final Restaurant r;
  final Function() onTap;
  const RestaurantRowItem({
    required this.r,
    required this.onTap,
    super.key
    });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
        child: Card(
          child: ListTile(
            leading: const Icon(Icons.food_bank),
            trailing: const Icon(Icons.chevron_right),
            title: Text(
              r.name,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              r.averageRating.toString(),
              //r.reviews[0].get().toString(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}