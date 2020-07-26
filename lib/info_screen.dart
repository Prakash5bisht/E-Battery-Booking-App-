import 'package:flutter/material.dart';

/// this screen is shown when the bottom_sheet_screen appears
class InfoScreen extends StatefulWidget{
  InfoScreen({this.battery,this.batteryStatus});
  final  battery;
  final batteryStatus;
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> with SingleTickerProviderStateMixin{

  TabController _tabController; /// creates a controller which handles the tab changes

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column( /// widgets are shown in top-down manner using column
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            height: 20,
            child: TabBar(  /// this adds the sliding bar feature to the ui
              indicatorColor: Colors.white,
              unselectedLabelColor: Colors.grey[400],
              controller: _tabController, /// adds a controller which handles the tab changes
              tabs: <Widget>[
                /// icons which appears on the tabs
                Tab(
                  icon: Icon(Icons.battery_unknown),
                ),
                Tab(
                  icon: Icon(Icons.info),
                )
              ],
            ),
            /// adds decoration to the TabBar
            decoration: BoxDecoration(
              color: widget.battery < 20 ? Colors.red :
              widget.battery >= 20 && widget.battery < 50 ? Colors.orangeAccent : Colors.green, /// this add a condition to
              borderRadius: BorderRadius.only(                        /// which changes tab color on the basis of battery percentage
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
              ),
            ),
          ),
        ),
       Expanded(
         flex: 2,
         child: Container(
           /// shows the screen for each tab respectively
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
                     '${widget.batteryStatus}',
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
       ),
      ],
    );
  }
}
