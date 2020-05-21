import 'package:cookiej/cookiej/page/public/user_page.dart';
import 'package:flutter/material.dart';

class UserNameSpan extends StatelessWidget {

  final String screenName;
  final TextStyle style;

  const UserNameSpan(this.screenName, {this.style});
  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Text(
        screenName??'',
        style: style??Theme.of(context).primaryTextTheme.bodyText2,
      ),
      onTap:(()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>UserPage(screenName:screenName))))
    );
  }
}