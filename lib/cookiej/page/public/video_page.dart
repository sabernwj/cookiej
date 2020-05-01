import 'package:cookiej/cookiej/model/video.dart';
import 'package:cookiej/cookiej/model/video_raw.dart';
import 'package:cookiej/cookiej/net/url_api.dart';
import 'package:cookiej/cookiej/page/widget/cookiej_video_player/cookiej_video_player.dart';
import 'package:flutter/material.dart';

class VideoPage extends StatefulWidget {

  final Video video;
  const VideoPage({Key key,@required this.video}) : super(key: key);


  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  Future<Map> videoRawTask;

  @override
  void initState() {
    videoRawTask=UrlApi.getVideoRaw(widget.video.id);
    // videoRaw=VideoRaw.fromJson(await UrlApi.getVideoRaw(video.id, video.authorMid))
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final _theme=Theme.of(context);
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.black,
      //   leading: new BackButton(),
      //   title: Text(widget.video.displayName,style: _theme.primaryTextTheme.body2),
      // ),
      body: Container(
        color: Colors.black,
        child:FutureBuilder(
          future: videoRawTask,
          builder: (context,snaphot){
            if(snaphot.connectionState==ConnectionState.done){
              VideoRaw videoRaw;
              try{
                videoRaw=VideoRaw.fromJson(snaphot.data);
                videoRaw.urls=widget.video.urls;
                return CookieJVideoPlayer.videoRaw(
                  videoRaw: videoRaw,
                  title: widget.video.displayName,
                );
              }catch(e){
                return Center(
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.error_outline),
                      Text('解析视频地址错误错误',style: _theme.primaryTextTheme.body2,),
                      RaisedButton(
                        child: Text('点击重试'),
                        onPressed: (){
                          setState(() {
                            videoRawTask=UrlApi.getVideoRaw(widget.video.id);
                          });
                        }
                      )
                    ],
                  ),
                );
              }
            }else {
              return Container();
            }
          }
        )
      )
    );
  }

  @override
  void dispose(){
    super.dispose();
  }
}