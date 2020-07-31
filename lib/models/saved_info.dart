import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

/// this class listens to every changes in the variables and notifies every listener
class SavedInfo extends ChangeNotifier{
  int savedBatteryPercentage;
  BitmapDescriptor customMarker;
  double latitude;
  double longitude;
  String _userName;
  String _userId;
  String _password;

  void getBitmap(){
    /// this function calls convertPngToBitmap function and then store it to customMarker variable
    convertPngToBitmap().then((value){
     customMarker = BitmapDescriptor.fromBytes(value);
    });
  }

  /// it converts the png image to Bitmap to use that as our custom marker icon
  Future<dynamic> convertPngToBitmap() async{
    ByteData byteData = await rootBundle.load('images/battery.png');
    ui.Codec codec = await ui.instantiateImageCodec(byteData.buffer.asUint8List(), targetWidth: 85, targetHeight: 85,);
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    return(await frameInfo.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }

  String getUser(){
    return _userName;
  }

  void setUser(String email){
     _userName = email;
  }

  String getPassword(){
    return _password;
  }

  void setPassword(String password){
    _password = password;
  }

  void setUserId(String id){
    _userId = id;
  }

  bool signOutUser(){
    FirebaseDatabase.instance.reference().child('user').child('$_userId').update({
      'loggedIn': false
    });
    return true;
  }

}