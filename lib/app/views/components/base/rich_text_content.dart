import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookiej/app/config/config.dart';
import 'package:cookiej/app/model/collection.dart';
import 'package:cookiej/app/model/emotion.dart';
import 'package:cookiej/app/model/local/display_content.dart';
import 'package:cookiej/app/model/video.dart';
import 'package:cookiej/app/service/repository/emotion_repository.dart';
import 'package:cookiej/app/service/repository/picture_repository.dart';
import 'package:cookiej/app/views/components/base/image_set_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

///用于显示微博或评论中由链接产生的图片视频及其他微博应用

class RichTextContentWidget extends StatelessWidget {
  final List<DisplayContent> displayContentList;
  final TextStyle specialTextStyle;
  final TextStyle normalTextStyle;

  const RichTextContentWidget(
      {Key key,
      @required this.displayContentList,
      this.specialTextStyle,
      this.normalTextStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: _buildContent(context),
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }

  ///生成显示的内容部分
  List<Widget> _buildContent(BuildContext context) {
    final returnWidgets = <Widget>[];
    final listInlineSpan = <InlineSpan>[];
    final secondDisplayWidget = <Widget>[];
    var imgWidth = (MediaQuery.of(context).size.width - 32) / 3;
    final TextStyle _specialTextStyle =
        specialTextStyle ?? Theme.of(context).primaryTextTheme.bodyText2;
    final TextStyle _normalTextStyle =
        normalTextStyle ?? Theme.of(context).textTheme.bodyText2;
    displayContentList.forEach((displayContent) {
      switch (displayContent.type) {
        case ContentType.Text:
          listInlineSpan.add(
              TextSpan(text: displayContent.text, style: _normalTextStyle));
          break;
        case ContentType.Link:
          listInlineSpan.add(TextSpan(
              text: displayContent.text,
              style: _specialTextStyle,
              recognizer: TapGestureRecognizer()
              //..onTap=(()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>WebviewWithTitle(displayContent.info.urlLong))))
              ));
          break;
        case ContentType.Emotion:
          listInlineSpan.add(WidgetSpan(
              child: _buildEmotion(
                  EmotionRepository.getEmotion(displayContent.text),
                  _normalTextStyle.fontSize)));
          break;
        case ContentType.User:
          listInlineSpan.add(TextSpan(
              text: displayContent.text,
              style: _specialTextStyle,
              recognizer: TapGestureRecognizer()
              //..onTap=(()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>UserPage(screenName:displayContent.text.replaceAll(RegExp('@'), '')))))
              ));
          break;
        case ContentType.Image:
          secondDisplayWidget.add(ImageSetWidget(
              imgUrls: PictureRepository.getImgUrlsFromIds(
                  (displayContent.info.annotations[0].object as Collection)
                      .picIds),
              sinaImgSize: SinaImgSize.bmiddle));
          break;
        case ContentType.Video:
          //先展示下视频封面
          var video = (displayContent.info.annotations[0].object as Video);
          secondDisplayWidget.add(
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Image(
                  width: imgWidth * 1.8,
                  height: imgWidth * 1.2,
                  image: PictureRepository.getPictureFromUrl(video.image.url),
                  fit: BoxFit.cover,
                ),
                Stack(
                  children: <Widget>[
                    Positioned(
                      left: 1.0,
                      top: 1.0,
                      child: Icon(Icons.play_circle_outline,
                          size: 48, color: Colors.black54),
                    ),
                    Icon(Icons.play_circle_outline,
                        size: 48, color: Colors.white),
                  ],
                ),
                Positioned.fill(
                    child: Material(
                        color: Colors.transparent,
                        child: InkWell(onTap: () async {
                          //Navigator.push(context, MaterialPageRoute(builder: (context)=>VideoPage(video: video)));
                        })))
              ],
            ),
          );
          break;
        default:
          listInlineSpan.add(
              TextSpan(text: displayContent.text, style: _specialTextStyle));
      }
    });
    returnWidgets.add(Container(
      child: RichText(
        text: TextSpan(children: listInlineSpan),
      ),
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(top: 4, bottom: 4),
    ));
    returnWidgets.addAll(secondDisplayWidget);
    return returnWidgets;
  }

  Widget _buildEmotion(Emotion emotion, double size) {
    return Container(
      child: CachedNetworkImage(
        imageUrl: emotion.url,
        width: size + 2,
        height: size + 2,
      ),
      margin: EdgeInsets.symmetric(horizontal: 2),
    );
  }
}
