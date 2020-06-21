
import 'package:cookiej/cookiej/model/url_info.dart';
import 'package:cookiej/cookiej/provider/emotion_provider.dart';
import 'package:cookiej/cookiej/provider/url_provider.dart';
import 'package:cookiej/cookiej/utils/utils.dart';
import 'package:cookiej/cookiej/model/content.dart';

class DisplayContent{
  final ContentType type;
  final String text;
  final UrlInfo info;
  DisplayContent(this.type,this.text,{this.info});

  static final urlRegexStr=Utils.urlRegexStr;
  static final topicRegexStr=Utils.topicRegexStr;
  static final userRegexStr=Utils.userRegexStr;
  static final emotionRegexStr=Utils.emotionRegexStr;
  static final totalRegex=new RegExp("$urlRegexStr|$topicRegexStr|$userRegexStr|$emotionRegexStr");
  
  ///分析text成分，是否包含图片视频，链接内容等等
  static List<DisplayContent> analysisContent(Content content){//这里也可以用栈遍历的方式来判断，比如以@开头并且以空格结束，我们就认为它是一个@的特殊文本
    //文本分析
    var _text=content.longText!=null?content.longText.longTextContent:content.text;
    final matchs=totalRegex.allMatches(_text).toList();
    var textsList=_text.split(totalRegex);
    var _displayContentList=<DisplayContent>[];
    bool hasVideo=false;
    for(int i=0;i<textsList.length;i++){
      //添加普通文字
      if(textsList[i].trim().isNotEmpty){
        _displayContentList.add(DisplayContent(ContentType.Text, textsList[i]));
      }
      //添加普通文字之外的东西
      if(i<matchs.length){
        var _singleText=matchs[i].group(0);
        //Emotion表情
        if(_singleText.contains(RegExp(emotionRegexStr))){
          EmotionProvider.getEmotion(_singleText).success
            ?_displayContentList.add(DisplayContent(ContentType.Emotion, _singleText))
            :_displayContentList.add(DisplayContent(ContentType.Text,_singleText));
          continue;
        }
        //@用户昵称
        if(_singleText.contains(RegExp(userRegexStr))){
          _displayContentList.add(DisplayContent(ContentType.User,_singleText));
          continue;
        }
        //话题
        if(_singleText.contains(RegExp(topicRegexStr))){
          _displayContentList.add(DisplayContent(ContentType.Topic,_singleText));
        }
        //url链接
        if(_singleText.contains(RegExp(urlRegexStr))){
          //微博全文，else的都是短链接
          if(_singleText.contains(RegExp('http://m.weibo.cn/'))){
            _displayContentList.add(DisplayContent(ContentType.WeiboWebLink,'查看'));
          }
          else{
            var urlInfo=UrlProvider.getUrlInfo(_singleText).data??UrlInfo(annotations: []);
            //if(urlInfo.annotations.isNotEmpty) print('解析url成功');
            var displayText='\u{f0c1}网页链接';
            var contentType=ContentType.Link;
            try{
              if(urlInfo.annotations.length!=0&&urlInfo.annotations[0]!=null){
                switch(urlInfo.annotations[0].objectType){
                  case 'place':
                    contentType=ContentType.Place;
                    displayText='\u{f124}'+urlInfo.annotations[0].object.displayName;
                    break;
                  case 'video':
                    contentType=ContentType.Video;
                    if(hasVideo)  continue;
                    if(urlInfo.annotations[0].object.id==null) continue;
                    displayText='\u{f03d}'+urlInfo.annotations[0].object.displayName;
                    hasVideo=true;
                    break;
                  case 'collection':
                    contentType=ContentType.Image;
                    displayText=urlInfo.annotations[0].object.displayName;
                    break;
                  case 'webpage':
                    contentType=ContentType.Link;
                    break;
                  default:
                    displayText='\u{f18a}未知微博应用';
                }
              }
            }catch(e){
              print('解析url发生异常($_singleText),${contentType.toString()}类型,错误 ${e.toString()}');
              contentType=ContentType.Link;
            }

            _displayContentList.add(DisplayContent(contentType,displayText,info: urlInfo));
          }
        }
      }
    }
    return _displayContentList;
  }

  static String formatDisplayContentsToStr (List<DisplayContent> displayContents){
    return '';
  }
}
enum ContentType{
  ///普通文本
  Text,
  ///微博的网页链接
  WeiboWebLink,
  ///网页链接
  Link,
  ///@用户
  User,
  ///表情
  Emotion,
  ///图片
  Image,
  ///视频
  Video,
  ///回复
  Reply,
  ///地理位置信息
  Place,
  ///话题
  Topic
}