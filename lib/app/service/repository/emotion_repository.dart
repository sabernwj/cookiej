import 'package:cookiej/app/model/emotion.dart';
import 'package:cookiej/app/service/db/hive_service.dart';
import 'package:cookiej/app/service/error/app_error.dart';
import 'package:cookiej/app/service/net/api.dart';
import 'dart:convert';

class EmotionRepository {
  static get emotionBox => HiveService.emotionBox;

  static Emotion getEmotion(String name) => emotionBox.get(utf8);

  /// 增量更新emotionBox
  static Future<void> initLocalEmotionBox() async {
    var newMap = await getEmotionMapFromNet()
      ..removeWhere((key, value) => emotionBox.keys.contains(key));
    await emotionBox.putAll(newMap);
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
}
