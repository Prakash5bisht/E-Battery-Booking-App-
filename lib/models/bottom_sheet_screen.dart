import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sihproject/models/saved_info.dart';
import 'package:firebase_database/firebase_database.dart';

import '../info_screen.dart';
import '../renting_screen.dart';

class CustomBottomSheet{
  void myBottomSheet({var reference, BuildContext context}) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Container(
                    height: 200.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: StreamBuilder(
                        stream: reference.onValue,
                        builder: (context, AsyncSnapshot<Event> event) {
                          if (!event.hasData) {
                            return SpinKitChasingDots(
                              size: 20,
                              color: Colors.blue,
                            );
                          }
                          var myBattery = event.data.snapshot.value['battery'];
                          Provider.of<SavedInfo>(context)
                              .savedBatteryPercentage = myBattery;
                          var myBatteryStatus =
                          event.data.snapshot.value['status'];
                          return InfoScreen(
                            battery: myBattery,
                            batteryStatus: myBatteryStatus,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 4.0,
                ),
                Provider.of<SavedInfo>(context, listen: false).savedBatteryPercentage == null ||
                    Provider.of<SavedInfo>(context, listen: false).savedBatteryPercentage < 20
                    ? Container()
                    : Expanded(
                  child: MaterialButton(
                    height: 10.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text(
                      'Rent',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Color(0xff262626),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RentingScreen()));
                    },
                  ),
                ),
                SizedBox(
                  height: 4.0,
                ),
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
                    onPressed: () {
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