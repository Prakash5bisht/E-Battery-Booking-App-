import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sihproject/menu_screen.dart';
import 'package:sihproject/models/bottom_sheet_screen.dart';
import 'package:sihproject/models/saved_info.dart';


/// this is where user is taken after location_fetching_screen when app starts
class MainScreen extends StatefulWidget {
  MainScreen(this.latitude, this.longitude); /// the constructor(parameterised) of this class is called with
  /// latitude and longitude as arguments
  final double latitude;
  final double longitude;
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>(); /// a global scaffold key is created to access the parent scaffold widget
  double myLat;
  double myLong;
  List<Marker> markers = [];
  List<LatLng> coordinates = [];
//  Set<Polyline> polylines = {};
 // var location;
//  PolylinePoints polylinePoints = PolylinePoints();

  @override
  void initState() {
    super.initState();
    /// after state object of this class is created the variables are initialized
    /// and these are the things which are done first
    myLat = widget.latitude;
    myLong = widget.longitude;
    setLocation();
    Provider.of<SavedInfo>(context, listen: false).getBitmap();/// ths calls the getBitmap function of SavedInfo class
    addMarkers();
   // addPolylines();
  }

  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _initialCameraPosition;

  /// this sets the initial map camera position to users current location
  void setLocation() {
    _initialCameraPosition = CameraPosition(
      target: LatLng(myLat, myLong),
      zoom: 13.0,
    );
  }

  /// this handles the FloatingActionButton onPress event and changes the camera position to targeted coordinates
  static final CameraPosition _finalCameraPosition = CameraPosition(
    target: LatLng(26.8103905, 80.8751125),
    zoom: 19.0,
  );

//  void addPolylines() async {
//    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//        apiKey,
//        PointLatLng(myLat, myLong),
//        PointLatLng(26.8103905, 80.8751125),
//        travelMode: TravelMode.driving);
//
//    if(result.points.isNotEmpty){
//      result.points.forEach((PointLatLng point){
//        coordinates.add(LatLng(point.latitude, point.longitude));
//      }
//      );
//    }
//
//    setState(() {
//      polylines.add(
//        Polyline(
//          polylineId: PolylineId('route'),
//          color: Colors.green,
//          points: coordinates,
//          visible: true
//        )
//      );
//    });
//  }

  /// this function adds markers to the map
  void addMarkers() {
    Map<dynamic, dynamic> modules;

    FirebaseDatabase.instance    /// this establishes connection with the realtime database
        .reference()
        .child('modules')
        .once()
        .then((DataSnapshot snapshot) {

      modules = snapshot.value;  /// this transfers the data snapshot taken from the database to a map(module) since it(snapshot.value)
      /// returns a HashMap value

      setState(() {
        try {
          modules.entries.forEach((element) {  /// it iterate over every element in the map
            markers.add(Marker(               /// for every element a marker is added to the marker list
                markerId: MarkerId(element.key),
                icon:
                    Provider.of<SavedInfo>(context, listen: false).customMarker, /// it adds a custom battery marker icon instead of the old one
                draggable: false,
                position: LatLng(
                    element.value['location'][0],
                    element.value['location']
                        [1]), //values['location'][0], values['location'][1]
                infoWindow: InfoWindow(
                  title: element.key,
                ),
                onTap: () {  /// every marker has a onTap event listener which handles the onTap event.The name onTap is self explanatory
                  CustomBottomSheet().myBottomSheet(     /// whenever the user taps on the marker it shows a bottomSheet
                      reference: FirebaseDatabase.instance  /// where the battery details of the battery at that location is shown
                          .reference()
                          .child('modules')
                          .child(element.key),
                      context: context);
                }));
          });
        } catch (e) {
          print(e);
        }
      });

    });
  }

  /// this is the ui part
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[50],
      floatingActionButton: FloatingActionButton(  /// this is the button present at the bottom right which takes user to desired
        child: Icon(Icons.navigation),       /// coordinates when pressed
        onPressed: navigate,
        backgroundColor: Colors.green,
      ),
      drawer: Container(    /// this the side screen which opens up when menu button is pressed
        child: MenuScreen(),
        width: 250,
      ),
      body: SafeArea(
        child: Stack(  /// as the name suggests this lays the ui element on top of each other
          children: <Widget>[
            GoogleMap(     /// this is the first ui element, it shows the map which the user see
              mapType: MapType.normal,
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: (GoogleMapController controller) { /// this function handles the event which is called when map is created
                _controller.complete(controller);
              },
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              markers: Set.from(markers), /// this lays down the markers from the list of markers after converting list to set
          //    polylines: polylines,
            ),
            /// on top of google map a menu button is laid
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
                    _scaffoldKey.currentState.openDrawer(); /// it handles the onPress event when the menu button is pressed
                  }),
            )
          ],
        ),
      ),
    );
  }

  /// this function is called when the FloatingActionButton is pressed
  void navigate() async {
    final GoogleMapController controller = await _controller.future;
    controller
        .animateCamera(CameraUpdate.newCameraPosition(_finalCameraPosition));
  }
}
