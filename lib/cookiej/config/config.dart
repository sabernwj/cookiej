

import 'package:cookiej/cookiej/model/local/local_state.dart';

class Config{
  static const appkey='1532678245';
  static const appSecret='71663753d61d39daa0cd6a7689304c64';

//网上找的appkey
  static const appkey_1='211160679';
  static const appSecret_1='63b64d531b98c2dbff2443816f274dd3';

  static const redirectUri='https://api.weibo.com/oauth2/default.html';
  static const redirectUri_1='http://oauth.weico.cc';

  static const loginAccessesStorageKey='login_accesses';
  static const currentAccessStorageKey='current_access';
  static const accessStateStorageKey='access_state';

  static const themeNameStorageKey='theme_name';
  static const isDarkModeStorageKey='is_dark_mode';

  static const userInfoDB='UserInfo';
  static const userInfoDB_Id='uid';

  static const pictureDB='PictureInfo';
  static const pictureDB_id='picture_id';

  static const List<String> imgBaseUrlPool=[
    'http://wx1.sinaimg.cn/',
    'http://wx2.sinaimg.cn/',
    'http://wx3.sinaimg.cn/',
    'http://ww1.sinaimg.cn/',
    'http://ww2.sinaimg.cn/',
    'http://ww3.sinaimg.cn/',
    'http://tva2.sinaimg.cn/',
    'http://tvax3.sinaimg.cn/',
  ];
  static const String baseUrl='https://api.weibo.com';


}



class SinaImgSize{
  static const String thumbnail='thumbnail';
  static const String bmiddle='bmiddle';
  static const String large='large';
}


enum WeiboTimelineType{
  Public,
  Firends,
  Statuses,
  Bilateral,
  Reposts,
  User,
  Group
}
extension WeiboTimelineExtesnsion on WeiboTimelineType{

  String toStringNew(){
    return this.toString().split('.').last;
  }

  String get text=>[
    '公共',
    '朋友',
    '全部关注',
    '朋友圈',
    '转发',
    '用户'
  ][this.index];
}

enum CommentsType{
  Hot,
  Time
}

class CookieJHiveType{
  static const WeiboLite=0;
  static const UserLite=1;
  static const Annotations=2;
  static const DataObject=3;
  static const Weibos=4;
  static const WeiboTimelineType=5;
  static const LocalState=6;
  static const User=7;
}