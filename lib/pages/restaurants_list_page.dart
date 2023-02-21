//page that shows the list of restaurants in/around TH
//ideas for features:
// - list is searchable

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:restaurant_rater/managers/restaurants_collection_manager.dart';


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
  //controller to select which category?

  UniqueKey? _loginObserverKey;
  UniqueKey? _logoutObserverKey;

  @override
  void initState(){
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
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const Placeholder();
                    //todo: replace with login page
                  }
                ));
              },
              tooltip: "Log in",
              icon: const Icon(Icons.login),
            ),
          ],
      ),
      backgroundColor: Colors.grey[100],
      body: FirestoreListView<Restaurant>(
        query: RestaurantsCollectionManager.instance.allRestaurants,
        itemBuilder: (context, snapshot){
          Restaurant r = snapshot.data();
          return RestaurantRowItem(
            r: r,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return Placeholder();
                    //todo: replace with link to restaurant reviews page
                  }
                )
              );
              setState(() {});
            }
          );
        }
      ),
      drawer: AuthManager.instance.isSignedIn
      //todo: replace with drawer once created
        ? const Placeholder()
        : null,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(AuthManager.instance.isSignedIn) {
            //todo: show create new restaurant dialog
          }else{
            //todo: show log in dialog
          }
        },
        tooltip: 'Add Restaurant',
        child: const Icon(Icons.add),
      ),
    );
  }
}