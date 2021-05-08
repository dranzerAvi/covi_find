import 'package:covi_find/screens/root_screen/root_screen.dart';
import 'package:covi_find/screens/sign_in/sign_in_screen.dart';
import 'package:covi_find/services/authentification/authentification_service.dart';
import 'package:flutter/material.dart';

class AuthentificationWrapper extends StatelessWidget {
  static const String routeName = "/authentification_wrapper";
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthentificationService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return RootScreen();
        } else {
          return SignInScreen();
        }
      },
    );
  }
}
