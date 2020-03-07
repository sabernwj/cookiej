import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookiej/cookiej/action/access_state.dart';
import 'package:cookiej/cookiej/action/app_state.dart';
import 'package:cookiej/cookiej/page/login/login_page.dart';
import 'package:cookiej/cookiej/provider/picture_provider.dart';
import 'package:cookiej/cookiej/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class PersonalCenter extends StatelessWidget {

  final GlobalKey _displayUserNameKey=GlobalKey();
  @override
  Widget build(BuildContext context){
    final store=StoreProvider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          //设置按钮
          IconButton(
            iconSize: 24,
            icon: Icon(IconData(0xf1de,fontFamily: 'fontawesome')),
            onPressed: (){},
          ),
        ],
        bottom: PreferredSize(
          child: Expanded(
            flex: 3,
            child: Column(
              children:[
                Container(
                  child:Row(
                    children: <Widget>[
                      SizedBox(
                        child: CircleAvatar(backgroundImage: PictureProvider.getPictureFromId(store.state.currentUser.iconId),radius: 20),
                        width: 64,height: 64,
                      ),
                      Expanded(
                        child:ListTile(
                          
                          title:Row(
                            children:[
                              Text(store.state.currentUser.screenName,style: TextStyle(color:Colors.white,fontSize: 19)),
                              IconButton(icon: Icon(IconData(0xf0d7,fontFamily: 'fontawesome'),color: Colors.white,size: 24), onPressed: () async{
                                final RenderBox textDescription=_displayUserNameKey.currentContext.findRenderObject();
                                showMenu(
                                  context: _displayUserNameKey.currentContext,
                                  position:RelativeRect.fromLTRB(textDescription.localToGlobal(Offset.zero).dx, textDescription.localToGlobal(Offset.zero).dy,100, 0), 
                                  items: await getLocalUsersItems(store,context),
                                  //color: Colors.blue
                                );
                              }),
                            ]
                          ),
                          subtitle: Text(store.state.currentUser.description.isEmpty?'\u{3000}':store.state.currentUser.description,key: _displayUserNameKey,style: TextStyle(fontSize: 13,color: Colors.white70)),
                          trailing: IconButton(icon: Icon(IconData(0xf105,fontFamily: 'fontawesome'),color: Colors.white,size: 28,), onPressed: (){
                            store.dispatch(RemoveAccess(store.state.accessState.loginAccesses[store.state.currentUser.idstr]));
                          }),
                        ),
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(left:14,bottom: 10),
                ),
                Container(
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:[
                      FlatButton(onPressed: (){}, child: Column(
                        children:[
                          Text(store.state.currentUser.statusesCount.toString(),style: TextStyle(color:Colors.white,fontSize:16)),
                          Text('微博',style: TextStyle(color:Colors.white70,fontSize:13))
                        ]
                      )),
                      FlatButton(onPressed: (){}, child: Column(
                        children:[
                          Text(store.state.currentUser.friendsCount.toString(),style: TextStyle(color:Colors.white,fontSize:16)),
                          Text('关注',style: TextStyle(color:Colors.white70,fontSize:13))
                        ]
                      )),
                      FlatButton(onPressed: (){}, child: Column(
                        children:[
                          Text(store.state.currentUser.followersCount.toString(),style: TextStyle(color:Colors.white,fontSize:16)),
                          Text('粉丝',style: TextStyle(color:Colors.white70,fontSize:13))
                        ]
                      )),
                    ]
                  )
                )
              ]
            ),
          ), 
          preferredSize: Size.fromHeight(128),
        ),
      )
    );
  }

  Future<List<PopupMenuEntry>> getLocalUsersItems(Store<AppState> store,BuildContext context) async{
    var state=store.state;
    var itemList=<PopupMenuEntry>[];
    var userList=await UserProvider.getLocalAccessUsers(state.accessState);
    if(userList.success){
      userList.data.forEach((user){
        GlobalKey _itemKey=GlobalKey();
        itemList.add(PopupMenuItem(
          key: _itemKey,
          child:ListTile(
            leading: CircleAvatar(backgroundImage:PictureProvider.getPictureFromId(user.iconId,sinaImgSize: SinaImgSize.thumbnail)),
            title: Text(user.screenName),
            trailing: IconButton(padding: EdgeInsets.all(0), icon: Icon(Icons.remove_circle,color: Colors.red,), onPressed: (){
              Navigator.pop(context);
              store.dispatch(RemoveAccess(state.accessState.loginAccesses[user.idstr]));
            }),
            contentPadding: EdgeInsets.only(left: 0,right: 0,top: 0,bottom: 0),
            onTap: (){
              Navigator.pop(context);
              if(user.idstr!=store.state.accessState.currentAccess.uid){
                store.dispatch(UpdateCurrentAccess(store.state.accessState.loginAccesses[user.idstr]));
              }
            },
            selected: user.idstr==state.currentUser.idstr,
          ),
        ));
        itemList.add(PopupMenuDivider(height: 1,));
      });
      // for(int i=0;i<20;i++){
      //   itemList.add(PopupMenuItem(child: Text('喵喵机'),));
      // }
    }
    itemList.add(PopupMenuItem(
      child: Row(
        children:[
          IconButton(icon: Icon(Icons.add_circle,color: Colors.green,), onPressed: (){
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
          })
        ],
        mainAxisAlignment:MainAxisAlignment.center
      ),
    ));

    return itemList;
  }


}