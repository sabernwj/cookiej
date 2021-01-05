import 'package:flutter/material.dart';

class UserName extends StatelessWidget {
  final String screenName;
  final TextStyle style;

  const UserName(this.screenName, {this.style});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Text(
          screenName ?? '',
          style: style ?? Theme.of(context).primaryTextTheme.bodyText2,
        ),
        onTap: (() {
          // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   var name = screenName;
          //   name = name.replaceAll('@', '');
          //   return UserPage(screenName: name);
          // }));
        }));
  }
}
