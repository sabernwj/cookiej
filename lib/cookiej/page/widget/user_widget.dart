import 'package:cookiej/cookiej/model/user_lite.dart';
import 'package:cookiej/cookiej/page/public/user_page.dart';
import 'package:cookiej/cookiej/page/widget/user_icon.dart';
import 'package:cookiej/cookiej/provider/picture_provider.dart';
import 'package:cookiej/cookiej/utils/utils.dart';
import 'package:flutter/material.dart';

class UserWidget extends StatefulWidget {

  final UserLite userLite;

  const UserWidget({Key key, this.userLite}) : super(key: key);

  @override
  _UserWidgetState createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {

  UserLite user;

  @override
  void initState() {
    user=widget.userLite;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _theme=Theme.of(context);
    return Container(
      color: _theme.dialogBackgroundColor,
      child:ListTile(
        leading: UserIcon(PictureProvider.getPictureFromId(user.iconId),user:user),
        title: Text(
          user.screenName,
          style: _theme.primaryTextTheme.bodyText2,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Text(
              user.description,
              style: _theme.textTheme.subtitle2.merge(TextStyle(color:_theme.textTheme.bodyText1.color)),
            ),
            Text(
              '粉丝: ${Utils.formatNumToChineseStr(user.followersCount)}',
              style:_theme.textTheme.subtitle2,
            )
          ]
        ),
        // trailing: IconButton(
        //   icon: widget.type==FriendShipsType.Friends
        //     ?Icon(Icons.remove,color: Colors.red,)
        //     :Icon(Icons.add,color: Colors.green,),
        //   onPressed: (){

        //   }),
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UserPage(inputUser:user)));
        },
      ),
    );
  }
}