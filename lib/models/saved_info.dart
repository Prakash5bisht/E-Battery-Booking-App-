import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;


class SavedInfo extends ChangeNotifier{
  int savedBatteryPercentage;
  BitmapDescriptor customMarker;

  void getBitmap(){
    convertPngToBitmap().then((value){
     customMarker = BitmapDescriptor.fromBytes(value);
    });
  }

  Future<dynamic> convertPngToBitmap() async{
    ByteData byteData = await rootBundle.load('images/battery.png');
    ui.Codec codec = await ui.instantiateImageCodec(byteData.buffer.asUint8List(), targetWidth: 75, targetHeight: 75,);
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    return(await frameInfo.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }

}