import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sihproject/main_screen.dart';
import 'package:sihproject/models/saved_info.dart';
import 'package:sihproject/user_signin_signup_modules/Screens/components/already_have_an_account_acheck.dart';
import 'package:sihproject/user_signin_signup_modules/Screens/components/rounded_button.dart';
import 'package:sihproject/user_signin_signup_modules/Screens/components/rounded_input_field.dart';
import 'package:sihproject/user_signin_signup_modules/Screens/components/rounded_password_field.dart';
import 'package:sihproject/user_signin_signup_modules/Screens/signup_screen.dart';


String email;
String password;
class LoginScreen extends StatefulWidget {
  LoginScreen({this.uID,this.latitude, this.longitude});
  final String uID;
  final double latitude;
  final double longitude;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final databaseReference = FirebaseDatabase.instance.reference();
  Map<dynamic,dynamic> userSnapshot;

  @override
  void initState() {
    databaseReference.child('user').once().then((DataSnapshot snapshot){
      userSnapshot = snapshot.value;
    });
    super.initState();
  }

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
                  onChanged: (value) {
                    email = value;
                  },
                ),
                RoundedPasswordField(
                  onChanged: (value) {
                    password = value;
                  },
                ),
                RoundedButton(
                  text: "LOGIN",
                  press: () {
                   if(userSnapshot != null){
                     if(userSnapshot.containsKey(widget.uID)){
                      databaseReference.child('user').child('${widget.uID}').once().then((DataSnapshot snap){
                         if(snap.value['loggedIn'] == true){
                            showAlert(context, 'account already logged in to other device');
                         }
                         else{
                           if(snap.value['email'] == email && snap.value['password'] == password){
                             databaseReference.child('user').child('${widget.uID}').update({
                               'email': email,
                               'password': password,
                               'loggedIn': true
                             });
                             Provider.of<SavedInfo>(context, listen: false).setUser(email);
                             Navigator.push(context, MaterialPageRoute(builder: (context){
                               return MainScreen(latitude: widget.latitude, longitude: widget.longitude,);
                             }));
                           }
                           else{
                             showAlert(context, 'incorrect Id or password');
                           }
                         }
                       });
                     }
                     else{
                       showAlert(context, 'no account with this user name or password');
                     }
                   }
                   else{
                     showAlert(context, 'no account with this user name or password');
                   }
                  },
                ),
                SizedBox(height: size.height * 0.02),
                AlreadyHaveAnAccountCheck(
                  press: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SignUpScreen(uID: widget.uID, latitude: widget.latitude, longitude: widget.longitude,);
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

  showAlert( context, String alertText){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('oops!',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18.0,
              ),
            ),
            content: Text(
              alertText,
              style: TextStyle(
                fontWeight: FontWeight.w300,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: (){ /// when this button is pressed then the popup is dismissed
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }
}
