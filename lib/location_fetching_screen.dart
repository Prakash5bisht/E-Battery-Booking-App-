import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sihproject/main_screen.dart';

import 'main_screen.dart';

/// This is where the user's current location is fetched.It is a stateful widget which means its state can change
class LocationFetchingScreen extends StatefulWidget {
  @override
  _LocationFetchingScreenState createState() => _LocationFetchingScreenState();
}

class _LocationFetchingScreenState extends State<LocationFetchingScreen> {

  @override
  void initState() { /// whenever the state object of this class is created this method is called first
    super.initState();
    getCurrentLocation();
  }

  void getCurrentLocation() async{  /// this method calculates the current position of user
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high); /// position is calculated using the geolocator package(see pubspec.yaml)
   double longitude = position.longitude;
   double latitude = position.latitude;
   /// once done the user is automatically navigated to the next screen which is the main screen
   Navigator.push(context, MaterialPageRoute(builder: (context){
     return MainScreen(latitude, longitude);
   }));
  }

  /// while all location fetching process happens behind, we show user the following
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SpinKitChasingDots(
              color: Colors.blue,
              size: 30.0,
            ),
            SizedBox(height: 20.0,),
            Text('Getting your location...',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
            ),
            ),
          ],
        )
      ),
    );
  }
}
