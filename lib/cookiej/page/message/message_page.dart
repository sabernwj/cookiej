import 'package:cookiej/cookiej/action/app_state.dart';
import 'package:cookiej/cookiej/config/style.dart';
import 'package:cookiej/cookiej/page/widget/custom_button.dart';
import 'package:cookiej/cookiej/provider/picture_provider.dart';
import 'package:cookiej/cookiej/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {


  @override
  Widget build(BuildContext context) {
    final _theme=Theme.of(context);
    return StoreBuilder<AppState>(
      builder:(context,store){
        return Scaffold(
          appBar: AppBar(
            title:Text('消息')
          ),
          body:CustomScrollView(
            slivers:[
              SliverToBoxAdapter(
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    customListTitle(
                      leadingChild:Icon(Icons.alternate_email,color: _theme.primaryTextTheme.subhead.color),
                      title: Text('@我的微博和评论')
                    ),
                    customListTitle(
                      leadingChild:Icon(Icons.message,color: _theme.primaryTextTheme.subhead.color),
                      title:Text('收到的评论')
                    ),
                    customListTitle(
                      leadingChild: Icon(Icons.favorite,color: _theme.primaryTextTheme.subhead.color),
                      title: Text('收到的赞'),
                      tralling: countNoticeWidget(99, context)
                    ),
                    customListTitle(
                      leadingChild: Icon(Icons.mail,color: _theme.primaryTextTheme.subhead.color),
                      title:Text('陌生人消息')
                    )
                  ],
                ),
              ),
              SliverFixedExtentList(
                itemExtent: 72,
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return customListTitle(
                      leadingChild: ClipOval(child:Image(
                        image: PictureProvider.getPictureFromId(store.state.currentUser.iconId),
                      )),
                      title:Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('用户$index'),
                          Text(
                            '唧唧复唧唧、唧唧复唧唧、唧唧复唧唧、唧唧复唧唧、唧唧复唧唧、唧唧复唧唧、唧唧复唧唧、唧唧复唧唧、唧唧复唧唧、唧唧复唧唧、',
                            style: _theme.primaryTextTheme.overline,
                            softWrap: false,
                          ),
                        ],
                      ),
                      tralling: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('03/16',style: _theme.primaryTextTheme.overline),
                          countNoticeWidget(index, context)
                        ],
                      )
                    );
                  }
                ),
              ),
            ]
          )
        );
      }
    );
  }
  Widget countNoticeWidget(int count,BuildContext context){
    final _themeText=Theme.of(context).primaryTextTheme;
    return Material(
      shape:StadiumBorder(),
      color: Theme.of(context).primaryColor,
      child: Container(
        padding: EdgeInsets.all(4),
        child: Text(
          Utils.formatNumToChineseStr(count),
          style: _themeText.body2.copyWith(fontSize: 14,letterSpacing: count<10?8:0),
        ),
      ),
    );
  }

  Widget customListTitle({
    Widget leadingChild,
    Widget title,
    Widget tralling,
    Widget subtitle, 
    void Function() onTap
  }){
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical:8 ,horizontal:14),
      leading: ClipOval(
        child: Container(
          height: 48,width: 48,
          child: leadingChild,
          color: Theme.of(context).primaryColor,
        ),
      ),
      onTap: onTap??(){},
      title: title,
      subtitle: subtitle,
      trailing: tralling,
    );
  }
}


enum MessageItemType{
  Fixed,
  Dynamic
}