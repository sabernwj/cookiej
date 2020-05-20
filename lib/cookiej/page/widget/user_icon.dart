import 'package:cookiej/cookiej/model/user_lite.dart';
import 'package:cookiej/cookiej/page/public/user_page.dart';
import 'package:cookiej/cookiej/provider/picture_provider.dart';
import 'package:flutter/material.dart';

class UserIcon extends StatelessWidget {

  final UserLite user;
  final String id;
  final String screenName;
  final ImageProvider img;

  const UserIcon(this.img,{Key key, this.user, this.id, this.screenName}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: CircleAvatar(backgroundImage: img??PictureProvider.getPictureFromId(user?.iconId),radius: 20),
      onTap: (){
        if(user==null&&id==null&&screenName==null) return;
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UserPage(userId: id,screenName: screenName,inputUser: user,)));
      },
    );
  }
}