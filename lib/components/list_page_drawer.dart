import 'package:flutter/material.dart';
import 'package:restaurant_rater/pages/restaurants_list_page.dart';
import 'package:restaurant_rater/pages/users_reviews_page.dart';

import '../managers/auth_manager.dart';

class ListPageDrawer extends StatelessWidget {
  const ListPageDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const Text(
              "RoseRestaurantRater",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 28.0,
                color: Colors.white,
              ),
            ),
          ),
          ListTile(
            title: const Text("Restaurants"),
            leading: const Icon(Icons.person),
            onTap: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return const RestaurantListPage();
              }));
            },
          ),
          ListTile(
            title: const Text("My Reviews"),
            leading: const Icon(Icons.people),
            onTap: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return const UserReviewsListPage();
              }));
            },
          ),
          const Spacer(),
          ListTile(
            title: const Text("Logout"),
            leading: const Icon(Icons.logout),
            onTap: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
              AuthManager.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}
