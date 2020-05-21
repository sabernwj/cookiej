import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/config/style.dart';
import 'package:cookiej/cookiej/model/local/display_content.dart';
import 'package:cookiej/cookiej/model/video.dart';
import 'package:cookiej/cookiej/page/public/weibo_page.dart';
import 'package:cookiej/cookiej/page/widget/no_ink_behavior.dart';
import 'package:cookiej/cookiej/page/widget/weibo/weibo_list_mixin.dart';

import 'package:cookiej/cookiej/page/widget/weibo/weibo_video_widget.dart';
import 'package:cookiej/cookiej/page/widget/weibo/weibo_video_widget2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class TrendPage extends StatefulWidget {
  @override
  _TrendPageState createState() => _TrendPageState();
}

class _TrendPageState extends State<TrendPage> with WeiboListMixin{

  RefreshController _refreshController=RefreshController(initialRefresh:false);

  @override
  void initState() {
    weiboListInit(WeiboTimelineType.Public,extraParams: {
      'feature':'3'
    });
    isStartLoadDataComplete=startLoadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final _theme=Theme.of(context);
    return CustomScrollView(
        //mainAxisSize: MainAxisSize.min,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child:Container(
              color: _theme.dialogBackgroundColor,
              height: 92,
              margin:EdgeInsets.only(top:12),
              child: Material(
                color:Colors.transparent,
                child:Row(
                  mainAxisAlignment:MainAxisAlignment.spaceAround,
                  children:[
                    _buildExpandedItem(Icons.map, Colors.teal[300], '疫情地图', _theme,size: 26),
                    _buildExpandedItem(Icons.location_on, Colors.blue[400], '同城', _theme),
                    _buildExpandedItem(IconData(0xf219,fontFamily: CookieJTextStyle.iconFontFamily), Colors.orange[700], '超级话题', _theme,size: 23),
                    _buildExpandedItem(FontAwesomeIcons.chartBar, Colors.red[400], '榜单', _theme,size: 23)
                  ]
                )
              ),
            ),
          ),
          SliverToBoxAdapter(
            child:_buildGridviewWidget(
              '大家都在搜', '全部',
              <Widget>[
                _buildGridItem([
                  Expanded(child: Text('建议将HPV疫苗纳入国家免疫规划',overflow: TextOverflow.ellipsis,)),
                  _buildNoticeString('沸')
                ]),
                _buildGridItem([
                  Expanded(child: Text('中国不存在隐性军费问题',overflow: TextOverflow.ellipsis,)),
                  _buildNoticeString('新')
                ]),
                _buildGridItem([
                  Expanded(child: Text('建议离婚过错方少分或不分财产',overflow: TextOverflow.ellipsis,)),
                  _buildNoticeString('沸')
                ]),
                _buildGridItem([
                  Expanded(child: Text('建议取消生三孩以上处罚',overflow: TextOverflow.ellipsis,)),
                  _buildNoticeString('沸')
                ])
              ],
              _theme
            )
          ),
          SliverToBoxAdapter(
            child:_buildGridviewWidget(
              '热门话题', '全部',
              <Widget>[
                _buildGridItem([
                  Expanded(child: Text('#521表白文案#',overflow: TextOverflow.ellipsis,)),
                ]),
                _buildGridItem([
                  Expanded(child: Text('#我是唱作人#',overflow: TextOverflow.ellipsis,)),
                ]),
                _buildGridItem([
                  Expanded(child: Text('#全国政协十三届三次会议#',overflow: TextOverflow.ellipsis,)),
                ]),
                _buildGridItem([
                  Expanded(child: Text('#上辈子约好的爱情#',overflow: TextOverflow.ellipsis,)),
                ])
              ],
              _theme
            )
          ),
          SliverToBoxAdapter(child:Container(height:12)),
          FutureBuilder(
              future: isStartLoadDataComplete,
              builder: (context,snaphot){
                if(snaphot.data!=WeiboListStatus.complete) return SliverToBoxAdapter(child:Center(child:CircularProgressIndicator()));              
                var videoElementList=<VideoElement>[];
                weiboList.forEach((weibo){
                  bool hasVideo=false;
                  String text='@${weibo.user.screenName}:';
                  Video video;
                  DisplayContent.analysisContent(weibo).forEach((content) {
                    if(content.type==ContentType.Text
                    ||content.type==ContentType.Topic
                    ||content.type==ContentType.User) text+=content.text;
                    if(content.type==ContentType.Video&&!hasVideo){
                      video=(content.info.annotations[0].object as Video);
                      hasVideo=true;
                    }
                  });
                  if(hasVideo){
                    videoElementList.add(VideoElement(text,video,onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>WeiboPage(weibo.id)));
                    }));
                  }
                });
                //print(videoElementList.length);
                if(videoElementList.isEmpty){
                  return Center(
                    child:Text('没有找到视频')
                  );
                }
                Widget returnWidget;
                returnWidget=SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context,index)=>Container(child:WeiboVideoWidget2(videoElement: videoElementList[index],weibo: weiboList[index],),margin:EdgeInsets.only(bottom:12)),
                    childCount: videoElementList.length
                  )
                );
                return returnWidget;
              },
            )
          
          
          
        ],
      );
  }

  Widget _buildGridviewWidget(String leftTitle,String rightTitle,List<Widget> grids,ThemeData _theme){
    return Container(
      color: _theme.dialogBackgroundColor,
      margin:EdgeInsets.only(top:12),
      child:Material(
        color:Colors.transparent,
        child:Column(
          children: <Widget>[
            InkWell(
              onTap:(){},
              child:Padding(
              padding:EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                child: Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(leftTitle,style: _theme.textTheme.subtitle2.merge(TextStyle(fontSize: 14)),),
                    Text(rightTitle,style: _theme.textTheme.subtitle2.merge(TextStyle(fontSize: 14,color:_theme.accentColor)),),
                  ],
                ),
              )
            ),
            Divider(height:1),
            Padding(
              padding: EdgeInsets.symmetric(vertical:3),
                child: Material(
                  color:Colors.transparent,
                  child:ScrollConfiguration(
                    behavior: NoInkBehavior(),
                     child: WaterfallFlow.count(
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(0),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      children: grids,
                    )
                )
                ),
            )
          ],
        )
      ),
    );
  }

  Widget _buildGridItem(List<Widget> children){
    return InkWell(
      child:Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        ),
      ),
      onTap:(){}
    );
  }

  Widget _buildNoticeString(String text){
    return Container(
      padding:EdgeInsets.symmetric(vertical: 2,horizontal: 2),
      margin: EdgeInsets.symmetric(horizontal:2),
      child:Text(text??'',style: (TextStyle(color:Colors.white,fontSize: 12))),
      decoration: BoxDecoration(
        borderRadius:BorderRadius.circular(3),
        color:Colors.red[400],
      ),
    );
  }
  Widget _buildExpandedItem(IconData iconData,Color color,String text, ThemeData theme,{double size}){
    return Expanded(
      child:InkWell(
        onTap:(){},
        child:SizedBox.expand(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(21),
                child:Container(
                  width:42,
                  height:42,
                  color:color,
                    child:Icon(
                    iconData,
                    color: Colors.white,
                    size: size??28,
                  )
                )
              ),
              Text(text,style:theme.textTheme.subtitle2)
            ],
          )
        )
      )
    );
  }
}