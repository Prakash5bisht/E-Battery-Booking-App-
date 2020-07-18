import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  InfoScreen(this.battery);
  final  battery;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            child: Icon(Icons.info_outline,color: Colors.white,),
            decoration: BoxDecoration(
              color: battery<=20 ? Colors.red : Colors.green,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0)),
            ),
          ),
        ),
        Expanded(flex: 2 ,child: Text('$battery')),
      ],
    );
  }
}
