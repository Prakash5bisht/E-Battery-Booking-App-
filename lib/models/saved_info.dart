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
  String _user;

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
    return _user;
  }

  void setUser(String email){
     _user = email;
  }

}