import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:restaurant_rater/pages/restaurants_list_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RoseRestaurantRater',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RestaurantListPage(),
    );
  }
}
