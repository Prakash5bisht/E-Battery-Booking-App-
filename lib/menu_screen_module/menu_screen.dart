import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sihproject/location_fetching_screen.dart';
import 'package:sihproject/main.dart';
import 'package:sihproject/menu_screen_module//reusable_list_tile.dart';
import 'package:sihproject/menu_screen_module/menu_tabs/about_tab.dart';
import 'package:sihproject/menu_screen_module/menu_tabs/feedback_tab.dart';
import 'package:sihproject/models/saved_info.dart';

/// this screen is shown when the menu button in main_screen is pressed
class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          /// the widgets in this screen are laid in top-down manner using column
          children: <Widget>[
            Center(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        /// adds user profile icon
                        Icons.person_pin,
                        color: Colors.blueGrey,
                        size: 50.0,
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        Provider.of<SavedInfo>(context, listen: false)
                            .getUser(),
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
            SizedBox(
              height: 3.0,
            ),
            Container(
              padding: EdgeInsets.all(17.0),
              child: Column(
                children: <Widget>[
                  ReusableListTile(
                    icon: Icons.verified_user,
                    iconColor: Colors.green,
                    title: 'Profile',
                    onPressed: () {
                      print('profile');
                    },
                  ),
                  ReusableListTile(
                    icon: Icons.feedback,
                    iconColor: Colors.blue,
                    title: 'Feedback',
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> FeedbackTab()));
                    },
                  ),
                  ReusableListTile(
                    icon: Icons.exit_to_app,
                    iconColor: Colors.grey,
                    title: 'Log Out',
                    onPressed: () {
                      Provider.of<SavedInfo>(context, listen: false)
                              .signOutUser()
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MyApp()))
                          : print('not done');
                    },
                  ),
                  ReusableListTile(
                    icon: Icons.info_outline,
                    iconColor: Colors.deepOrangeAccent,
                    title: 'About Us',
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AboutTab()));
                    },
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
