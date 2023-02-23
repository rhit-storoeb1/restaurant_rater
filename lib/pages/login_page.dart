//Login page
//ideally we could use rose login but that doesn't exist on this platform
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:restaurant_rater/pages/email_login_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class LoginButton extends StatelessWidget {
  final String title;
  final Function() callback;
  const LoginButton({super.key, required this.title, required this.callback});
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 300.0,
        height: 40.0,
        margin: const EdgeInsets.all(20),
        child: ElevatedButton(onPressed: callback, child: Text(title)));
  }
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          const Expanded(
            child: Center(
                child: Text("RoseRestaurantRater",
                    style: TextStyle(fontSize: 50))),
          ),
          LoginButton(
              title: "Log in",
              callback: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return const EmailLoginPage(isNewUser: false);
                }));
              }),
          LoginButton(
            title: "Sign Up",
            callback: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return const EmailLoginPage(isNewUser: true);
              }));
            },
          ),
        ],
      ),
    );
  }
}
