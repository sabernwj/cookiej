import '../model/emotion.dart';
import 'package:cookiej/cookiej/net/extra_api.dart';
import 'package:cookiej/cookiej/provider/provider_result.dart';
import 'dart:async';

class EmotionProvider{
  static Map<String,Emotion> _emotionsMap=new Map();

  static Future<List<Map>> _downloadEmotions() async{
    return await ExtraApi.getEmotions();
  }

  static Future<void> loadEmotions() async{
    final mapList=await _downloadEmotions();
    mapList.forEach((map)=>_emotionsMap[map['phrase']]=Emotion.fromMap(map));
  }

  static ProviderResult<Emotion> getEmotion(String emotionName){
    if(_emotionsMap.containsKey(emotionName)){
      return ProviderResult(_emotionsMap[emotionName], true);
    }else{
      return ProviderResult.failed();
    }
  }

  ///获取当前内存中的emotion分组信息
  static ProviderResult<Map<String,List<Emotion>>> getEmotionGroup(){
    if(_emotionsMap.length==0) return ProviderResult.failed();
    var returnMap=new Map<String,List<Emotion>>();
    _emotionsMap.values.forEach((emotion){
      if(!returnMap.containsKey(emotion.category)) returnMap[emotion.category]=List<Emotion>();
      returnMap[emotion.category].add(emotion);
    });
    return ProviderResult(returnMap, true);
  }
}