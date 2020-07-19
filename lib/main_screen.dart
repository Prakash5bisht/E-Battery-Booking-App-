import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sihproject/info_screen.dart';
import 'package:sihproject/menu_screen.dart';


int battery;

class MainScreen extends StatefulWidget {
  MainScreen(this.latitude, this.longitude);
  final double latitude;
  final double longitude;
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  double myLat;
  double myLong;
  List<Marker> markers = [];

  var location;

  @override
  void initState() {
    super.initState();
    myLat = widget.latitude;
    myLong = widget.longitude;
    setLocation();
    // getData();
    setMarkers();
  }

  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _initialCameraPosition;

  void setMarkers() {
    List<dynamic> list = [];
    Map<dynamic, dynamic> values = {};

    FirebaseDatabase.instance
        .reference()
        .child('modules')
        .once()
        .then((DataSnapshot snapshot) {
      list = snapshot.value;
      print(list[1]);

      setState(() {
        for (int i = 1; i < list.length; i++) {
          values = list[i];

          markers.add(Marker(
              markerId: MarkerId(i.toString()),
              draggable: false,
              position: LatLng(values['location'][0], values['location'][1]),
              infoWindow: InfoWindow(
                title: i.toString(),
              ),
              onTap: () {
                myBottomSheet(FirebaseDatabase.instance
                    .reference()
                    .child('modules')
                    .child(i.toString()));
              }));
        }
      });
    });

  }

  void setLocation() {
    _initialCameraPosition = CameraPosition(
      target: LatLng(myLat, myLong),
      zoom: 13.0,
    );
  }

//void getData() {
//  FirebaseDatabase.instance.reference().child('1').onValue.listen((event){
//     _snapshot = event.snapshot;
//
//   });

//   battery = _snapshot.value['battery'];
//   location = _snapshot.value['location'];
//}

  static final CameraPosition _finalCameraPosition = CameraPosition(
    target: LatLng(26.8103905, 80.8751125),
    zoom: 19.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[50],
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.navigation),
        onPressed: navigate,
        backgroundColor: Colors.green,
      ),
      drawer: Container(child: MenuScreen(), width: 250,),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              markers: Set.from(markers),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 10.0),
              child: MaterialButton(
                      padding: EdgeInsets.only(top: 1.0, left: 0.8),
                      height: 40.0,
                      minWidth: 40.0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)
                      ),
                      color: Color(0xff262626),
                      child: Icon(Icons.menu, color: Colors.white,),
                      onPressed: (){
                       _scaffoldKey.currentState.openDrawer();
                      }
                  ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> navigate() async {
    final GoogleMapController controller = await _controller.future;
    controller
        .animateCamera(CameraUpdate.newCameraPosition(_finalCameraPosition));
  }


  void myBottomSheet(var reference) {
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
                          // 26.909304 , 80.9757538
                          if (!event.hasData) {
                            return SpinKitChasingDots(
                              size: 20,
                              color: Colors.blue,
                            );
                          }
                          var myBattery = event.data.snapshot.value['battery'];
                          return InfoScreen(myBattery);
                        },
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 4.0,),
                Expanded(
                  child: MaterialButton(
                    height: 10.0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    child: Text(
                      'Rent',
                    style: TextStyle(color: Colors.white),
                    ),
                    color: Color(0xff262626),
                    onPressed: (){
                     print('ok');
                    },
                  ),
                ),
                SizedBox(height: 4.0,),
                Expanded(
                  child: MaterialButton(
                    height: 10.0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    child: Text(
                      'Ok',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Color(0xff262626),
                    onPressed: (){
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


