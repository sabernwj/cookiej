import 'package:cookiej/cookiej/model/user.dart';
import 'package:cookiej/cookiej/model/user_lite.dart';
import 'package:cookiej/cookiej/page/public/user_page.dart';
import 'package:cookiej/cookiej/page/widget/custom_button.dart';
import 'package:cookiej/cookiej/page/widget/user_icon.dart';
import 'package:cookiej/cookiej/page/widget/weibo/user_name_span.dart';
import 'package:cookiej/cookiej/provider/picture_provider.dart';
import 'package:cookiej/cookiej/provider/provider_result.dart';
import 'package:cookiej/cookiej/provider/user_provider.dart';
import 'package:cookiej/cookiej/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserListPage extends StatefulWidget {

  final String screenName;
  final String uid;
  final FriendShipsType type;

  const UserListPage({Key key, this.screenName, this.uid,@required this.type}) : super(key: key);

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {

  Future<ProviderResult<List<User>>> userListTask;


  @override
  void initState() {
    super.initState();
    if(widget.screenName==null&&widget.uid==null) Navigator.pop(context);
    switch (widget.type) {
      case FriendShipsType.Followers:
        userListTask=UserProvider.getFollowers(uid:widget.uid,screenName: widget.screenName);
        break;
      case FriendShipsType.Friends:
      userListTask=UserProvider.getFriends(uid:widget.uid,screenName: widget.screenName);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var _theme=Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.screenName+widget.type.text),
      ),
      body: FutureBuilder(
        future: userListTask,
        builder: (context,snaphot){
          if(snaphot.hasData){
            if(snaphot.data.success){
              List<User> userList=snaphot.data.data;
              return Container(
                color: _theme.dialogBackgroundColor,
                margin: EdgeInsets.symmetric(vertical:16),
                child:ListView.separated(
                  itemCount: userList.length+1,
                  separatorBuilder: (context,index)=>Divider(
                    height: 1.0,
                    indent: 16,
                    endIndent: 16,
                  ),
                  itemBuilder: (context,index){
                    if(index==userList.length){
                      return Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical:32),
                        child: Text( '接口没有足够的权限，只能显示到这里啦',style: _theme.textTheme.subtitle2,),
                      );
                    }
                    var user=userList[index];
                    return ListTile(
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
                      trailing: IconButton(
                        icon: widget.type==FriendShipsType.Friends
                          ?Icon(Icons.remove,color: Colors.red,)
                          :Icon(Icons.add,color: Colors.green,),
                        onPressed: (){

                        }),
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UserPage(inputUser:user)));
                      },
                    );
                  }
                )
              );
            }
            else return Container(
              
              child:Text('没有找到相关信息')
            );
          }
          if(snaphot.hasError){
            return Container(
              child: Text(snaphot.error.toString()),
            );
          }
          return Center(child:  CircularProgressIndicator());
        }
      ),
    );
  }
}

enum FriendShipsType{
  Friends,
  Followers
}
extension FriendShipsTypeExtension on FriendShipsType{
  String get text=>[
    '关注的人',
    '的粉丝'
  ][this.index];
}