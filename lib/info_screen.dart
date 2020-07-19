import 'package:flutter/material.dart';

class InfoScreen extends StatefulWidget{
  InfoScreen({this.battery});
  final  battery;

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> with SingleTickerProviderStateMixin{

  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            height: 20,
            child: TabBar(//Icon(Icons.info_outline,color: Colors.white,),
              indicatorColor: Colors.white,
              unselectedLabelColor: Colors.grey[400],
              controller: _tabController,
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.battery_unknown),
                ),
                Tab(
                  icon: Icon(Icons.info),
                )
              ],
            ),
            decoration: BoxDecoration(
              color:  Colors.green, //widget.battery<=20 ? Colors.red :
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0)),
            ),
          ),
        ),
       Expanded(
         flex: 2,
         child: Container(
           child: TabBarView(
             controller: _tabController,
             children: <Widget>[
               Card(
                 elevation: 0,
                 child: Center(
                   child: Text(
                     '${widget.battery}%',
                     style: TextStyle(
                       fontWeight: FontWeight.w500,
                       fontSize: 30.0,
                       color: Color(0xff808080)
                     ),
                   ),
                 ),
               ),
               Card(
                 elevation: 0,
                 child: Center(
                   child: Text(
                       'charging',
                     style: TextStyle(
                         fontWeight: FontWeight.w500,
                         fontSize: 20.0,
                         color: Color(0xff808080)
                     ),
                   ),
                 ),
               )
             ],
           ),
         ),
       )
       // Expanded(flex: 2 ,child: Text('${widget.battery}')),
      ],
    );
  }
}
