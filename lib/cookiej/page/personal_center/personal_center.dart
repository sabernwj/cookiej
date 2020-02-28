import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PersonalCenter extends StatefulWidget {
  @override
  _PersonalCenterState createState() => _PersonalCenterState();
}

class _PersonalCenterState extends State<PersonalCenter> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
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
                        child: CircleAvatar(backgroundImage: CachedNetworkImageProvider('https://tvax3.sinaimg.cn/crop.0.0.959.959.180/0084m18bly8gby349s6koj30qn0qnta4.jpg'),radius: 20),
                        width: 64,height: 64,
                      ),
                      Expanded(
                        child:Container(
                          child: Column(
                            children: <Widget>[
                              Text('用户名',style: TextStyle(color:Colors.white,fontSize: 19)),
                              Text('个人简介',style: TextStyle(fontSize: 13,color: Colors.white70))
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                          height: 64,
                          margin: const EdgeInsets.only(left: 12),
                        ),
                      ),
                      //预留一下微博组件标题右边内容
                      Row(
                        children: <Widget>[IconButton(icon: Icon(IconData(0xf107,fontFamily: 'fontawesome'),color: Colors.white,size: 28,), onPressed: (){})],
                        mainAxisAlignment: MainAxisAlignment.end,
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(left:14,right:14,bottom: 14),
                ),
                Container(
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:[
                      FlatButton(onPressed: (){}, child: Column(
                        children:[
                          Text('20',style: TextStyle(color:Colors.white,fontSize:16)),
                          Text('微博',style: TextStyle(color:Colors.white70,fontSize:13))
                        ]
                      )),
                      FlatButton(onPressed: (){}, child: Column(
                        children:[
                          Text('16',style: TextStyle(color:Colors.white,fontSize:16)),
                          Text('关注',style: TextStyle(color:Colors.white70,fontSize:13))
                        ]
                      )),
                      FlatButton(onPressed: (){}, child: Column(
                        children:[
                          Text('4396',style: TextStyle(color:Colors.white,fontSize:16)),
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



}