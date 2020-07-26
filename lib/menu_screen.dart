import 'package:flutter/material.dart';

/// this screen is shown when the menu button in main_screen is pressed
class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column( /// the widgets in this screen are laid in top-down manner using column
        children: <Widget>[
          Center(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Column(
                  children: <Widget>[
                    Icon( /// adds user profile icon
                      Icons.supervised_user_circle,
                      color: Colors.blueGrey,
                      size: 50.0,
                    ),
                    SizedBox(height: 5.0,),
                    Text(
                      'Profile',
                      style: TextStyle(
                        color: Color(0xff404040),
                        fontWeight: FontWeight.w500,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ListTile(
         // TODO
          )
        ],
      ),
    );
  }
}
