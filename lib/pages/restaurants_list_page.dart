//page that shows the list of restaurants in/around TH
//ideas for features:
// - list is searchable

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:restaurant_rater/components/list_page_drawer.dart';
import 'package:restaurant_rater/managers/restaurants_collection_manager.dart';
import 'package:restaurant_rater/pages/login_page.dart';
import 'package:restaurant_rater/pages/restaurant_detail_page.dart';

import '../components/restaurants_row_component.dart';
import '../managers/auth_manager.dart';
import '../models/restaurant.dart';

class RestaurantListPage extends StatefulWidget {
  const RestaurantListPage({super.key});

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  final nameTextController = TextEditingController();
  final addressTextController = TextEditingController();
  final categoryTextController = TextEditingController();
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

  void dispose() {
    nameTextController.dispose();
    addressTextController.dispose();
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
      body: FirestoreListView<Restaurant>(
          query: RestaurantsCollectionManager.instance.allRestaurants,
          itemBuilder: (context, snapshot) {
            Restaurant r = snapshot.data();
            return RestaurantRowItem(
                r: r,
                onTap: () async {
                  await Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return RestaurantDetailPage(r.documentId!);
                  }));
                  setState(() {});
                });
          }),
      drawer: AuthManager.instance.isSignedIn
          //todo: replace with drawer once created
          ? const ListPageDrawer()
          : null,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (AuthManager.instance.isSignedIn) {
            showCreateRestaurantDialog(context);
          } else {
            showMustLogInDialog(context);
          }
        },
        tooltip: 'Add Restaurant',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showCreateRestaurantDialog(BuildContext context) {
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
                  controller: nameTextController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter the name',
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
                    labelText: 'Enter the address',
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
                    labelText: 'Enter the category',
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
                  RestaurantsCollectionManager.instance.add(
                      name: nameTextController.text,
                      address: addressTextController.text,
                      category: categoryTextController.text);
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

  Future<void> showMustLogInDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Login Required"),
          content: const Text(
              "You must be signed in to post.  Would you like to sign in now?"),
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
              child: const Text("Go sign in"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const LoginPage();
                  },
                ));
              },
            ),
          ],
        );
      },
    );
  }
}
