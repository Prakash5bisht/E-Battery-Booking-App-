import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/saved_info.dart';

/// this screen is shown when the menu button in main_screen is pressed
class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column( /// the widgets in this screen are laid in top-down manner using column
          children: <Widget>[
            Center(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Column(
                    children: <Widget>[
                      Icon( /// adds user profile icon
                        Icons.supervised_user_circle,
                        color: Colors.blueGrey,
                        size: 50.0,
                      ),
                      SizedBox(height: 5.0,),
                      Text(
                        Provider.of<SavedInfo>(context,listen: false).getUser(),
                        style: TextStyle(
                          color: Color(0xff404040),
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 3.0,),
            Container(
              padding: EdgeInsets.all(12.0),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.verified_user, color: Colors.green,),
                    title: Center(child: Text('profile')),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                      onPressed: (){
                        print('user');
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
