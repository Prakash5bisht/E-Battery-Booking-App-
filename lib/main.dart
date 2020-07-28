import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sihproject/location_fetching_screen.dart';
import 'package:sihproject/models/saved_info.dart';
import 'package:sihproject/user_signin_signup_modules/Screens/Welcome/welcome_screen.dart';


void main() {
  ///a familiar function from where execution starts
  ///this calls a function (runApp) which calls the MyApp class constructor
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// i have used provider package by flutter team to manage state
    return ChangeNotifierProvider(
      create: (context) => SavedInfo(),/// SavedInfo i the class which listens to every change in its
      /// variables and notifies to every Listener
      child: MaterialApp(       /// this is what every part of our app is wrapped under(self explanatory)
        home: LocationFetchingScreen(), /// this takes user to the new screen as the name suggests
      ),
    );
  }
}


