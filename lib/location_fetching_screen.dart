import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:provider/provider.dart';
import 'package:sihproject/main_screen.dart';
import 'package:sihproject/models/saved_info.dart';

import 'main_screen.dart';
import 'user_signin_signup_modules/Screens/welcome_screen.dart';

/// This is where the user's current location is fetched.It is a stateful widget which means its state can change
class LocationFetchingScreen extends StatefulWidget {
  @override
  _LocationFetchingScreenState createState() => _LocationFetchingScreenState();
}

class _LocationFetchingScreenState extends State<LocationFetchingScreen> {

 // String _platformImei;

  @override
  void initState() { /// whenever the state object of this class is created this method is called first
    super.initState();
    getCurrentLocation();
  }

  void getCurrentLocation() async{  /// this method calculates the current position of user
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high); /// position is calculated using the geolocator package(see pubspec.yaml)
   double longitude = position.longitude;
   double latitude = position.latitude;
    Provider.of<SavedInfo>(context, listen: false).getBitmap();
    initPlatformState(latitude, longitude);
  }


  void initPlatformState(double lat, double long) async{
    String platformImei;
    try{
      platformImei = await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
      Provider.of<SavedInfo>(context,listen: false).setUserId(platformImei);

      Map<dynamic,dynamic> userSnapshot;
      FirebaseDatabase.instance.reference().child('user').once().then((DataSnapshot snapshot){
        userSnapshot = snapshot.value;

        if(userSnapshot != null){
          if(userSnapshot.containsKey(platformImei)){
            FirebaseDatabase.instance.reference().child('user').child('$platformImei').once().then((DataSnapshot snap){
              if(snap.value['loggedIn'] == true){
                setState(() {
                  Provider.of<SavedInfo>(context, listen: false).setUser(snap.value['email']);
                  Provider.of<SavedInfo>(context, listen: false).setPassword(snap.value['password']);
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return MainScreen(latitude: lat, longitude: long,);
                  }));
                });
              }
              else{
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return WelcomeScreen(uID: platformImei ,latitude: lat, longitude: long,);
                }));
              }
            });

          }
          else{
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return WelcomeScreen(uID: platformImei ,latitude: lat, longitude: long,);
            }));
          }
        }
        else{
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return WelcomeScreen(uID: platformImei,latitude: lat, longitude: long,);
          }));
        }
      });

    }catch(e){
      print(e);
    }

    if(!mounted) return;
//
//    setState(() {
//      _platformImei = platformImei;
//         Navigator.push(context, MaterialPageRoute(builder: (context){
//     return MainScreen(latitude: lat, longitude: long,);
//   }));
//    });

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
