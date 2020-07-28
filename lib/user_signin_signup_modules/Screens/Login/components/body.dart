import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sihproject/user_signin_signup_modules/Screens/Signup/signup_screen.dart';
import 'package:sihproject/user_signin_signup_modules/Screens/components/already_have_an_account_acheck.dart';
import 'package:sihproject/user_signin_signup_modules/Screens/components/rounded_button.dart';
import 'package:sihproject/user_signin_signup_modules/Screens/components/rounded_input_field.dart';
import 'package:sihproject/user_signin_signup_modules/Screens/components/rounded_password_field.dart';

class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "LOGIN",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.03),
              SvgPicture.asset(
                "images/bicycle.svg",
                height: size.height * 0.25,
                color: Colors.green,
              ),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                hintText: "Your Email",
                onChanged: (value) {},
              ),
              RoundedPasswordField(
                onChanged: (value) {},
              ),
              RoundedButton(
                text: "LOGIN",
                press: () {},
              ),
              SizedBox(height: size.height * 0.02),
              AlreadyHaveAnAccountCheck(
                press: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SignUpScreen();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
