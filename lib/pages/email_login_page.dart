import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:email_validator/email_validator.dart';

import '../managers/auth_manager.dart';

//pulled from moviequotes
class EmailLoginPage extends StatefulWidget {
  final bool isNewUser;
  const EmailLoginPage({super.key, required this.isNewUser});
  @override
  State<EmailLoginPage> createState() => _EmailLoginPageState();
}

class _EmailLoginPageState extends State<EmailLoginPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UniqueKey? _loginObserverKey;

  @override
  void initState(){
    _loginObserverKey = AuthManager.instance.addLoginObserver(() {
      Navigator.of(context).popUntil((route) => route.isFirst);
    });
    super.initState();
  }

  @override
  void dispose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    AuthManager.instance.removeObserver(_loginObserverKey!);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              widget.isNewUser ? "Create a user" : "Log in"),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 250),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                    controller: emailTextController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                      labelText: "Email",
                      hintText: "Must be a valid email format"),
                    validator: (String? value) {
                      if (value == null ||
                          value.isEmpty ||
                          !EmailValidator.validate(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                    obscureText: true,
                    controller: passwordTextController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        labelText: "Password",
                        hintText: "Passwords must be at least 6 characters"),
                    validator: (String? value) {
                      if (value == null || value.isEmpty || value.length < 6) {
                        return 'Please enter a valid password';
                      }
                      return null;
                    }),
              ),
              SizedBox(
                height: 40.0,
                width: 220.0,
                child: ElevatedButton(
                    child: Text(widget.isNewUser ? "Sign up" : "Log in"),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (widget.isNewUser) {
                          AuthManager.instance.createNewUserEmailPassword(
                            context: context,
                            email: emailTextController.text,
                            password: passwordTextController.text,
                          );
                        } else {
                          AuthManager.instance.loginExistingUserEmailPassword(
                            context: context,
                            email: emailTextController.text,
                            password: passwordTextController.text,
                          );
                        }
                      } else {
                        print("Invalid Form: try again");
                      }
                    }),
              ),
            ],
          ),
        ));
  }
}