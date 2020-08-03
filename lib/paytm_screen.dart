import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaytmScreen extends StatefulWidget {
  @override
  _PaytmScreenState createState() => _PaytmScreenState();
}

class _PaytmScreenState extends State<PaytmScreen> {


  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Container(),
        ),
      ),
    );
  }
}
