

import 'package:cookiej/cookiej/model/local/local_state.dart';

class Config{
  static const appkey='1532678245';
  static const appSecret='71663753d61d39daa0cd6a7689304c64';

  static const appkey_0='2200697181';
  static const appSecret_0='d66e9e1528ef89669e3ffa22f0f8aaf4';
  static const redirectUri_0='http://06peng.com';

//网上找的appkey

  static const redirectUri='https://api.weibo.com/oauth2/default.html';


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
  static const String small='small';
  static const String mw690='mw690';
  static const String mw1024='mw1024';
  static const String mw2048='mw2048';

}


enum WeiboTimelineType{
  Public,
  Firends,
  Statuses,
  Bilateral,
  Reposts,
  User,
  Group,
  Mentions
}
extension WeiboTimelineExtesnsion on WeiboTimelineType{

  String toStringNew(){
    return this.toString().split('.').last;
  }

  String get text=>[
    '公共',
    '朋友',
    '全部关注',
    '好友圈',
    '转发',
    '用户'
    '@我的微博'
  ][this.index];
}

enum CommentsType{
  Hot,
  Time,
  Mentions,
  ByMe,
  ToMe
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

enum FunctionCallBack{
  UserPageRefresh
}