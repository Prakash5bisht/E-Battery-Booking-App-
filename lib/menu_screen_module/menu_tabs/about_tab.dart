import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AboutTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(
                color: Color(0xff263238),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 10.0, right: 8.0),
                  child: Column(
                   children: <Widget>[
                     Row(
                       children: <Widget>[
                         Flexible(
                           child: SvgPicture.asset(
                             'images/bicycle.svg',
                             height: size.height * 0.15,
                             color: Colors.green,
                           ),
                         ),
                         SizedBox(width: 10.0,),
                         Text(
                           'E-Parivahan',
                           style: TextStyle(
                             color: Colors.white,
                             fontWeight: FontWeight.w500,
                             fontFamily: 'Rowdies',
                             letterSpacing: 1.0,
                             fontSize: 40.0
                           ),
                         )
                       ],
                     ),
                     Text(
                       '1.0.0',
                       style: TextStyle(
                           color: Colors.white,
                           fontWeight: FontWeight.w500,
                           fontFamily: 'Rowdies',
                           fontSize: 20.0
                       ),
                     )
                   ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text(
                        'E-Parivahan is your e-battery renting friend.This is a "pay-as-you-go" application.'
                            'To do so you first need to register yourself and then open the app and you will see our swapping stations.'
                            'This app gives you realtime status of each battery.Just find the station closest to your location, rent it on one-tap and you are good to go.',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.chevron_left, color: Colors.grey,),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        ),
                        Text('BACK', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.blueGrey),)
                      ],
                    )
                  ],
                ),
              )
            )
          ],
        )
      ),
    );
  }
}
