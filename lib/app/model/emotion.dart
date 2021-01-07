import 'package:cookiej/app/service/db/hive_service.dart';
import 'package:hive/hive.dart';

part 'emotion.g.dart';

@HiveType(typeId: HiveBoxType.emotionBox)
class Emotion {
  @HiveField(0)
  String phrase;

  @HiveField(1)
  String url;

  @HiveField(2)
  String category;

  @HiveField(3)
  bool hot;

  @HiveField(4)
  bool common;

  @HiveField(5)
  bool isValid=true;

  Emotion({this.phrase, this.url, this.category, this.hot, this.common});

  Emotion.fromMap(map) {
    phrase = map['phrase'];
    url = map['url'];
    category = map['category'];
    hot = map['hot'];
    common = map['common'];
  }
}
