import 'package:cookiej/app/provider/global_view_model.dart';
import 'package:cookiej/app/service/db/hive_service.dart';
import 'package:cookiej/app/views/pages/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  Future<void> _initService;

  @override
  void initState() {
    _initService = () async {
      await HiveService.preInit();
    }();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: FutureBuilder(
            future: _initService,
            builder: (context, snaphot) {
              if (snaphot.connectionState == ConnectionState.done) {
                return ChangeNotifierProvider(
                  create: (_) => GlobalViewModel(),
                  child: Selector<GlobalViewModel, ThemeData>(
                      selector: (_, provider) => provider.currentTheme,
                      builder: (context, theme, _) {
                        return new MaterialApp(
                            title: '饼干微博', home: Index(), theme: theme);
                      }),
                );
              }
              return Container();
            }),
        onWillPop: () async {
          final platform = MethodChannel('android/back/desktop');
          //通知安卓返回,到手机桌面
          try {
            final bool out = await platform.invokeMethod('backDesktop');
            if (out) debugPrint('返回到桌面');
          } on PlatformException catch (e) {
            debugPrint("通信失败(设置回退到安卓手机桌面:设置失败)");
            print(e.toString());
          }
          return false;
        });
  }
}
