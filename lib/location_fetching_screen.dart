import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sihproject/main_screen.dart';

import 'main_screen.dart';

class LocationFetchingScreen extends StatefulWidget {
  @override
  _LocationFetchingScreenState createState() => _LocationFetchingScreenState();
}

class _LocationFetchingScreenState extends State<LocationFetchingScreen> {

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }



  void getCurrentLocation() async{
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
   double longitude = position.longitude;
   double latitude = position.latitude;
   print(latitude);
   print(longitude);
   Navigator.push(context, MaterialPageRoute(builder: (context){
     return MainScreen(latitude, longitude);
   }));
  }

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
