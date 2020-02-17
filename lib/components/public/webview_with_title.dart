//import 'package:cookiej/utils/localstorageHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';


class WebviewWithTitle extends StatefulWidget{

  final String url;
  @override
  _WebviewWithTitleState createState()=>_WebviewWithTitleState();
  WebviewWithTitle(this.url);
  
}

class _WebviewWithTitleState extends State<WebviewWithTitle> {
  @override
  void initState(){
    super.initState();
    final _flutterWebviewPlugin=new FlutterWebviewPlugin();
    _flutterWebviewPlugin.onStateChanged.listen((state){
      if(state.type==WebViewState.finishLoad){
        //暂时注释掉，用于给Webview设置cookie
        // final cookie=(LocalstorageHelper.getFromStorage('cookie') as Map<String,String>);
        // cookie.forEach((key,value){
        //   key=key.replaceAll(RegExp('\"'), '').replaceAll(RegExp(' '), '');
        //   value=value.replaceAll(RegExp('\"'), '').replaceAll(RegExp(' '), '');
        //   _flutterWebviewPlugin.evalJavascript('document.cookie=\'$key=$value\'');
        // });
        //切换appbar的标题为当前网页标题
        _flutterWebviewPlugin.evalJavascript('document.title').then((reuslt)=>setState(()=>_textWidget=Text(reuslt.replaceAll(RegExp('\"'), ''))));
      }
    });
  }

  Text _textWidget=Text('网页链接');
  @override
  Widget build(BuildContext context) {
    // WebViewController _controller;
    // return new Scaffold(
    //   appBar: AppBar(title: _textWidget),
    //   body: WebView(
    //     initialUrl: widget.url,
    //     javascriptMode: JavascriptMode.unrestricted,
    //     onWebViewCreated: ((controller)=>_controller=controller),
    //     onPageFinished: ((url){
    //       _controller.getTitle().then((reuslt)=>setState(()=>_textWidget=Text(reuslt)));
    //     }),
    //   )
    // );
    return new WebviewScaffold(
      url: widget.url,
      appBar: AppBar(title:_textWidget),
    );
  }
}