import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Center(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Column(
                  children: <Widget>[
                    Icon(
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

          )
        ],
      ),
    );
  }
}
