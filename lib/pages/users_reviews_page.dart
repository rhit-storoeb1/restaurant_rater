//page that shows the list of reviews by current User

import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:restaurant_rater/components/list_page_drawer.dart';
import 'package:restaurant_rater/components/review_row_component.dart';
import 'package:restaurant_rater/managers/reviews_collection_manager.dart';
import 'package:restaurant_rater/pages/login_page.dart';
import 'package:restaurant_rater/pages/review_detail_page.dart';

import '../managers/auth_manager.dart';
import '../models/review.dart';

class UserReviewsListPage extends StatefulWidget {
  const UserReviewsListPage({super.key});

  @override
  State<UserReviewsListPage> createState() => _UserReviewsListPageState();
}

class _UserReviewsListPageState extends State<UserReviewsListPage> {
  //controller to select which category?

  UniqueKey? _loginObserverKey;
  UniqueKey? _logoutObserverKey;

  @override
  void initState() {
    super.initState();
    _showRestaurants();
    _loginObserverKey = AuthManager.instance.addLoginObserver(() {
      setState(() {});
    });
    _logoutObserverKey = AuthManager.instance.addLogoutObserver(() {
      setState(() {});
    });
  }

  void _showRestaurants() {
    setState(() {
      //todo: set flags here if needed
    });
  }

  @override
  void dispose() {
    super.dispose();
    //category selector
    AuthManager.instance.removeObserver(_loginObserverKey!);
    AuthManager.instance.removeObserver(_logoutObserverKey!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("RoseRestaurantRater"),
        actions: AuthManager.instance.isSignedIn
            ? null
            : [
                IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return const LoginPage();
                    }));
                  },
                  tooltip: "Log in",
                  icon: const Icon(Icons.login),
                ),
              ],
      ),
      backgroundColor: Colors.grey[100],
      body: FirestoreListView<Review>(
          query: ReviewsCollectionManager.instance.reviewsForUser(),
          itemBuilder: (context, snapshot) {
            Review r = snapshot.data();
            return ReviewRowItem(
              r: r,
              showRestName: true,
              onTap: () async {
                await Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return ReviewDetailPage(r.documentId!);
                }));
              },
            );
          }),
      drawer: AuthManager.instance.isSignedIn
          //todo: replace with drawer once created
          ? const ListPageDrawer()
          : null,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // if (AuthManager.instance.isSignedIn) {
          //   //todo: show create new restaurant dialog
          // } else {
          //   //todo: show log in dialog
          // }
        },
        tooltip: 'Add Restaurant',
        child: const Icon(Icons.add),
      ),
    );
  }
}
