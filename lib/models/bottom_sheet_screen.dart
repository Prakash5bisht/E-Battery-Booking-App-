import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sihproject/models/saved_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sihproject/subscription_screen.dart';

import '../info_screen.dart';
import '../renting_screen.dart';

/// this is screen which is shown when the user taps on marker
class CustomBottomSheet{
  void myBottomSheet({var reference, BuildContext context, double latitude, double longitude}) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            /// used column to show ui elements in top-down fashion
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded( /// this enables the widget inside it to occupy as much space available in vertical direction
                  flex: 5, /// determines the ratio of how much of available space this particular widget will take
                  child: Container(
                    height: 200.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      /// this listens to every change in the data in database and shows changes at realtime
                      child: StreamBuilder(
                        stream: reference.onValue,
                        builder: (context, AsyncSnapshot<Event> event) {
                          if (!event.hasData) {
                            return SpinKitChasingDots(  /// this is shown to when while the data is being extracted from database
                              size: 20,
                              color: Colors.blue,
                            );
                          }
                          var myBattery = event.data.snapshot.value['battery'];
                          Provider.of<SavedInfo>(context)
                              .savedBatteryPercentage = myBattery;
                          var myBatteryStatus =
                          event.data.snapshot.value['status'];
                          /// after data extraction is done this screen is shown
                          return InfoScreen(
                            battery: myBattery,
                            batteryStatus: myBatteryStatus,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(  /// this adds gap between the widgets
                  height: 4.0,
                ),
                Provider.of<SavedInfo>(context, listen: false).savedBatteryPercentage == null || /// this adds a condition and notifies every listener
                    Provider.of<SavedInfo>(context, listen: false).savedBatteryPercentage < 60   /// under which if the battery percentage is less than 20 then an empty container is shown
                    ? Container()
                    : Expanded(
                  child: MaterialButton(  /// else the rent button is shown
                    height: 10.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text(
                      'Rent',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Color(0xff262626),
                    onPressed: () {   /// when this button is pressed then user is taken to the rent_screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubscriptionScreen(lat: latitude, long: longitude,)));
                    },
                  ),
                ),
                SizedBox(
                  height: 4.0,
                ),
                /// this adds another button to the column below rent button
                Expanded(
                  child: MaterialButton(
                    height: 10.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text(
                      'Ok',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Color(0xff262626),
                    onPressed: () {  /// when this button is pressed the bottom sheet(this screen) is dismissed
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}