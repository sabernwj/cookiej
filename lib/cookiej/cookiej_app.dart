

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cookiej/cookiej/action/access_state.dart';
import 'package:cookiej/cookiej/action/app_state.dart';
import 'package:cookiej/cookiej/action/theme_state.dart';
import 'package:cookiej/cookiej/event/notice_audio_event.dart';
import 'package:cookiej/cookiej/event/string_msg_event.dart';
import 'package:cookiej/cookiej/model/user.dart';
import 'package:cookiej/cookiej/page/boot_page.dart';
import 'package:cookiej/cookiej/reducer/app_reducer.dart';
import 'package:cookiej/cookiej/event/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:redux/redux.dart';


class CookieJAPP extends StatefulWidget {
  @override
  _CookieJState createState() => _CookieJState();
}

class _CookieJState extends State<CookieJAPP> {

  AudioCache noticeAudioPlayer;
  final store=Store<AppState>(
    appReducer,
    middleware: middleware,
    initialState: AppState(
      accessState:AccessState.init(),
      currentUser: User(),
      themeState: ThemeState.init()
    )
  );
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: StoreBuilder<AppState>(
        builder: (context,store){
          return new MaterialApp(
            title: '饼干酱',
            home: BootPage(),
            theme: store.state.themeState.themeData,
          );
        },
      )
    );
  }

  @override
  void initState(){
    super.initState();
    noticeAudioPlayer= AudioCache(prefix:'audios/', fixedPlayer: AudioPlayer(mode:PlayerMode.LOW_LATENCY));
    eventBus.on<NoticeAudioEvent>().listen((event) {
      noticeAudioPlayer.play(event.assetPath);
    });
    eventBus.on<StringMsgEvent>().listen((event) {
      Fluttertoast.showToast(
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        msg: event.msg
      );
    });
  }

  @override
  void dispose(){
    
    Hive.close();
    super.dispose();
  }
}