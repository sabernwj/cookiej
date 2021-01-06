import 'package:cookiej/app/model/emotion.dart';
import 'package:cookiej/app/service/db/hive_service.dart';
import 'package:cookiej/app/service/error/app_error.dart';
import 'package:cookiej/app/service/net/api.dart';

class EmotionRepository {
  static Map<String, Emotion> get emotionMap =>
      HiveService.emotionBox.get(_localEmotionBoxKey);
  static final _emotionBox = HiveService.emotionBox;
  static const _localEmotionBoxKey = 'defaultEmotionBoxKey';

  static Emotion getEmotion(String name) => emotionMap[name];

  /// 增量更新emotionBox
  static Future<void> initLocalEmotionBox() async {
    var newMap = await getEmotionMapFromNet()
      ..removeWhere((key, value) => _emotionBox.keys.contains(key));
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
}
