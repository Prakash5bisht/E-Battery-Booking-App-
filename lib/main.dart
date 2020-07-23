import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sihproject/location_fetching_screen.dart';
import 'package:sihproject/models/saved_info.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SavedInfo(),
      child: MaterialApp(
        home: LocationFetchingScreen(),
      ),
    );
  }
}


