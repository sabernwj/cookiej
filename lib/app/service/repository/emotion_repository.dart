import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookiej/app/model/emotion.dart';
import 'package:cookiej/app/service/db/hive_service.dart';
import 'package:cookiej/app/service/error/app_error.dart';
import 'package:cookiej/app/service/net/api.dart';
import 'package:flutter/widgets.dart';

class EmotionRepository {
  static Map<String, Emotion> get emotionMap =>
      HiveService.emotionBox.get(_localEmotionBoxKey);
  static final _emotionBox = HiveService.emotionBox;
  static const _localEmotionBoxKey = 'defaultEmotionBoxKey';

  static Emotion getEmotion(String name) => emotionMap[name];

  static Widget getEmotionWidget(String name, double size) {
    var emotion=getEmotion(name);
    return Container(
      child: Image(
        image: Cache,
        width: size + 2,
        height: size + 2,
      ),
      margin: EdgeInsets.symmetric(horizontal: 2),
    );
  }

  /// 增量更新emotionBox
  static Future<void> initLocalEmotionBox() async {
    var newMap = await getEmotionMapFromNet()
      ..removeWhere((key, value) => _emotionBox.keys.contains(key));
    newMap.values.forEach((emotion) {
      var imageProvider=CachedNetworkImageProvider(emotion.url);
    });
    await _emotionBox.putAll({_localEmotionBoxKey: newMap});
  }

  static Future<Map<String, Emotion>> getEmotionMapFromNet() async {
    var url = '/2/emotions.json';
    var jsonRes = (await API.get(url)).data;
    if (jsonRes is List<dynamic>) {}
    try {
      Map<String, Emotion> emotionMap = {};
      (jsonRes as List).forEach((element) {
        var emotion = Emotion.fromMap(element);
        emotionMap[emotion.phrase] = emotion;
      });
      return emotionMap;
    } catch (e) {
      throw AppError(AppErrorType.DecodeJsonError, rawErrorInfo: e);
    }
  }


  ///获取当前内存中的emotion分组信息
  static Map<String,List<Emotion>> getEmotionGroup(){
    if(emotionMap.length==0) return null;
    var returnMap=new Map<String,List<Emotion>>();
    emotionMap.values.forEach((emotion){
      if(!returnMap.containsKey(emotion.category)) returnMap[emotion.category]=List<Emotion>();
      returnMap[emotion.category].add(emotion);
    });
    return returnMap;
  }
}
