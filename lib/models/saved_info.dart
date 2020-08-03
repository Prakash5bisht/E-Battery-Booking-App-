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
  String _diaplayName;
  var _profilePhotoUrl;
  String _oldPass;

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

  void setDisplayName(String myName){
    FirebaseDatabase.instance.reference().child('user').child('$_userId').update({
      'displayname': myName,
    });
    print(myName);
    _diaplayName = myName;
  }

  String getDisplayName(){
    FirebaseDatabase.instance.reference().child('user').child('$_userId').once().then((DataSnapshot snap){
      _diaplayName = snap.value['displayname'];
    });

    return _diaplayName;
  }

  void setPhotoUrl(var url){
    FirebaseDatabase.instance.reference().child('user').child('$_userId').update({
      'profilePhoto': url,
    });
    _profilePhotoUrl = url;
  }

  String getPhotoUrl(){
    FirebaseDatabase.instance.reference().child('user').child('$_userId').once().then((DataSnapshot snap){
      _profilePhotoUrl = snap.value['profilePhoto'];
    });
    return _profilePhotoUrl;
  }

  bool signOutUser(){
    FirebaseDatabase.instance.reference().child('user').child('$_userId').update({
      'loggedIn': false
    });
    return true;
  }

  void resetMyEmail(String newEmail){
    FirebaseDatabase.instance.reference().child('user').child('$_userId').update({
      'email': newEmail
    });
    _userName = newEmail;
  }

  void resetMyPassword(String newPassword){
    FirebaseDatabase.instance.reference().child('user').child('$_userId').update({
    'password': newPassword
    });
  }

  String getOldPassword(){
    FirebaseDatabase.instance.reference().child('user').child('$_userId').once().then((DataSnapshot snap){
       _oldPass = snap.value['password'];
    });
    return _oldPass;
  }

}