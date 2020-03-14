import '../model/emotion.dart';
import 'package:cookiej/cookiej/net/extra_api.dart';
import 'package:cookiej/cookiej/provider/provider_result.dart';
import 'dart:async';

class EmotionProvider{
  static Map<String,Emotion> _emotionsMap=new Map();

  static Future<List<Map>> _downloadEmotions() async{
    return await ExtraApi.getEmotions();
  }

  static void loadEmotions() async{
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
}