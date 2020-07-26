import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sihproject/menu_screen.dart';
import 'package:sihproject/models/bottom_sheet_screen.dart';
import 'package:sihproject/models/saved_info.dart';

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
  List<Polyline> polyLines = [];
  var location;

  @override
  void initState() {
    super.initState();
    myLat = widget.latitude;
    myLong = widget.longitude;
    setLocation();
    Provider.of<SavedInfo>(context, listen: false).getBitmap();
    addMarkers();
    addPolylines();
  }

  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _initialCameraPosition;

  void addPolylines(){
    setState(() {
      polyLines.add(
        Polyline(
          polylineId: PolylineId('pl'),
          color: Colors.green,
          points: []
        )
      );
    });
  }

  void addMarkers() {

    Map<dynamic, dynamic> modules;

    FirebaseDatabase.instance
        .reference()
        .child('modules')
        .once()
        .then((DataSnapshot snapshot) {

      modules = snapshot.value;

      setState(() {

        try{
          modules.entries.forEach((element) {
            markers.add(Marker(
                markerId: MarkerId(element.key),
                icon: Provider.of<SavedInfo>(context,listen: false).customMarker,
                draggable: false,
                position: LatLng(element.value['location'][0], element.value['location'][1]),//values['location'][0], values['location'][1]
                infoWindow: InfoWindow(
                  title: element.key,
                ),
                onTap: () {
                  CustomBottomSheet().myBottomSheet(reference: FirebaseDatabase.instance
                      .reference()
                      .child('modules')
                      .child(element.key),
                  context: context
                  );
                }));

          });
        }catch(e){
          print(e);
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
      drawer: Container(
        child: MenuScreen(),
        width: 250,
      ),
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0)),
                  color: Color(0xff262626),
                  child: Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _scaffoldKey.currentState.openDrawer();
                  }),
            )
          ],
        ),
      ),
    );
  }

  void navigate() async {
    final GoogleMapController controller = await _controller.future;
    controller
        .animateCamera(CameraUpdate.newCameraPosition(_finalCameraPosition));
  }

}
