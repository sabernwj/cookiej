import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/model/weibo_lite.dart';
import 'package:cookiej/cookiej/page/public/weibo_page.dart';
import 'package:cookiej/cookiej/page/widget/content_widget.dart';
import 'package:cookiej/cookiej/provider/picture_provider.dart';
import 'package:flutter/material.dart';

class WeiboWidgetMini extends StatelessWidget {

  final WeiboLite weibo;
  final Color backgroundColor;

  const WeiboWidgetMini({Key key,@required this.weibo, this.backgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _theme=Theme.of(context);
    return Material(
      color: backgroundColor??_theme.unselectedWidgetColor,
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>WeiboPage(weibo.id)));
        },
        child:Row(
          children: <Widget>[
            Image(
              image: getPicture(),
              fit: BoxFit.cover,
              width: 64,
              height: 64,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4,horizontal: 8),
                child: Column(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    Text('@${weibo.user?.screenName??''}',style: _theme.textTheme.bodyText2.copyWith(fontSize:_theme.textTheme.bodyText2.fontSize-0.5),),
                    ContentWidget(weibo,textStyle: _theme.textTheme.subtitle2,maxLines: 2,isLightMode: true,)
                  ]
                ),
              )
            )
          ]
        ),
      ),
    );
  }

  ImageProvider getPicture(){
    if(weibo.picUrls!=null&&weibo.picUrls.isNotEmpty)
      return PictureProvider.getPictureFromUrl(weibo.picUrls[0],sinaImgSize: SinaImgSize.bmiddle);
    return PictureProvider.getPictureFromId(weibo.user?.iconId);
  }
}