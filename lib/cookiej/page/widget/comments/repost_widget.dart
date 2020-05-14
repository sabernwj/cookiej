import 'package:cookiej/cookiej/model/weibo_lite.dart';
import 'package:cookiej/cookiej/page/public/user_page.dart';
import 'package:cookiej/cookiej/page/widget/content_widget.dart';
import 'package:cookiej/cookiej/provider/picture_provider.dart';
import 'package:cookiej/cookiej/utils/utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class RepostWidget extends StatelessWidget {

  final WeiboLite repost;
  RepostWidget(this.repost);

  @override
  Widget build(BuildContext context) {
    final _theme=Theme.of(context);
    return Container(
      child:Column(
        children: <Widget>[
          //标题栏
          Container(
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UserPage(inputUser:repost.user))),
                  child: SizedBox(child: CircleAvatar(backgroundImage:PictureProvider.getPictureFromId(repost.user.iconId)),width: 36,height: 36,),
                ),  
                Container(
                  child: Column(
                    children: <Widget>[
                      Text(repost.user.name,style: _theme.primaryTextTheme.bodyText2.merge(TextStyle(fontSize: _theme.primaryTextTheme.bodyText2.fontSize-2))),
                      Text(Utils.getDistanceFromNow(repost.createdAt),style: _theme.primaryTextTheme.overline),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  margin: const EdgeInsets.only(left: 10),
                ),
                //预留一下微博组件标题右边内容
              ],
            ),
          ),
          //转发内容正文
          Container(
            child: ContentWidget(repost,textStyle: TextStyle(fontSize:_theme.textTheme.bodyText2.fontSize-1.5),),
            margin: EdgeInsets.only(left:46),
          ),
          
        ],
      ),
      padding: const EdgeInsets.only(left: 12,right: 12,top: 12,bottom: 12),
      margin: const EdgeInsets.only(bottom: 1),
      color: _theme.dialogBackgroundColor,
    );
  }
}