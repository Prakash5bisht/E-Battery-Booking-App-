import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sihproject/user_signin_signup_modules/Screens/components/rounded_button.dart';
import 'package:sihproject/user_signin_signup_modules/Screens/constants.dart';
import 'package:sihproject/user_signin_signup_modules/Screens/login_screen.dart';
import 'package:sihproject/user_signin_signup_modules/Screens/signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({this.uID, this.latitude, this.longitude});
  final String uID;
  final double latitude;
  final double longitude;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "WELCOME TO E-PARIVAHAN",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                SizedBox(height: size.height * 0.05),
                SvgPicture.asset(
                  "images/vespa.svg",
                  height: size.height * 0.35,
                  color: Colors.blue,
                ),
                SizedBox(height: size.height * 0.05),
                RoundedButton(
                  text: "LOGIN",
                  press: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginScreen(uID: uID, latitude: latitude, longitude: longitude,);
                        },
                      ),
                    );
                  },
                ),
                RoundedButton(
                  text: "SIGN UP",
                  color: kPrimaryLightColor,
                  textColor: Colors.black,
                  press: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SignUpScreen(uID: uID,latitude: latitude, longitude: longitude,);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
