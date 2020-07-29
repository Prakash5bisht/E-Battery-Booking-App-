import 'package:flutter/material.dart';

class ReusableListTile extends StatelessWidget {
  ReusableListTile({this.icon, this.title, this.onPressed, this.iconColor});
  final Function onPressed;
  final IconData icon;
  final String title;
  final Color iconColor;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor,),
      title: Center(child: Text(title)),
      trailing: IconButton(
        icon: Icon(
          Icons.chevron_right,
          color: Colors.grey,
        ),
        onPressed: onPressed
      ),
    );
  }
}
