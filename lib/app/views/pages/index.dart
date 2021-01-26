import 'package:cookiej/app/service/db/assets_service.dart';
import 'package:cookiej/app/service/db/hive_service.dart';
import 'package:cookiej/app/views/pages/main/main_page.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  @override
  void initState() {
    Future.wait([
      Future.delayed(Duration(seconds: 1)),
      HiveService.init(),
      AssetsService.loadAppkeyData(),
    ]).then((_) {
      print('初始化完毕');

      // 这里不使用Get路由跳转的原因是，在LoginPage中返回MainPage时，MainPage不会被重建，里面的build方法不会被调用
      //Get.off(MainPage());
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainPage()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Theme.of(context).dialogBackgroundColor,
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image:
                          ExtendedAssetImageProvider('assets/images/icon.png')),
                  shape: BoxShape.circle)),
          Container(
            height: 12,
          ),
          Text('饼干微博',
              style: Theme.of(context)
                  .primaryTextTheme
                  .bodyText2
                  .merge(TextStyle(fontSize: 18))),
          Container(height: MediaQuery.of(context).size.height / 4),
        ]),
      ),
    ));
  }
}
