import 'package:cookiej/cookiej/model/local/edit_special_text.dart';
import 'package:cookiej/cookiej/net/api.dart';
import 'package:cookiej/cookiej/net/interceptors/access_interceptor.dart';
import 'package:cookiej/cookiej/net/weibo_api.dart';
import 'package:cookiej/cookiej/page/widget/custom_button.dart';
import 'package:cookiej/cookiej/provider/access_provider.dart';
import 'package:cookiej/cookiej/provider/emotion_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:cookiej/cookiej/page/widget/emotion_panel.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:extended_text_field/extended_text_field.dart';


class EditWeiboPage extends StatefulWidget {
  @override
  _EditWeiboPageState createState() => _EditWeiboPageState();
}

class _EditWeiboPageState extends State<EditWeiboPage> {

  final FocusNode _textFieldNode=FocusNode();
  double keyboardHeight=0;
  double emotionPanelHeight=0;
  bool isEmotionPanelShow=false;
  bool isKeyboardShow=true;

  List<Widget> imageGridList=List();
  TextEditingController _controller=TextEditingController();
  ///用于准备向发送接口输入的文本 
  String rawText='';
  List<Asset> assetList;

  @override
  void initState(){
    super.initState();
    ///重新读取用于Send的Access
    API.httpClientSend.interceptors.removeWhere((interceptor)=>interceptor is AccessInterceptor);
    AccessProvider.getAccessStateLocal().then((result){
      if(result.success){
        //result.data.loginAccesses.forEach((access)=>api)
        API.httpClientSend.interceptors.add(AccessInterceptor(result.data.currentAccess));
      }
    }).catchError((e)=>print(e));
    KeyboardVisibility.onChange.listen(
      (bool visible) {
        setState(() {
          // isKeyboardShow=visible??isKeyboardShow;
          if(visible!=null&&isKeyboardShow!=visible){
            isKeyboardShow=visible;
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _theme=Theme.of(context);
    keyboardHeight=MediaQuery.of(context).viewInsets.bottom;
    if(keyboardHeight>0){
      emotionPanelHeight=keyboardHeight;
    }
    return Scaffold(
      appBar: AppBar(
        title:Text('发微博')
      ),
      body:CustomScrollView(
        slivers: <Widget>[
            SliverToBoxAdapter(
              child: ExtendedTextField(
                controller: _controller,
                enableSuggestions: false,
                specialTextSpanBuilder: WeiboSpecialTextSpanBuilder(context),
                style:_theme.textTheme.bodyText2,
                focusNode: _textFieldNode,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal:10,
                    vertical:12
                  ),
                  hintText: '说点什么吧...'
                ),
                autofocus: true,
                autocorrect: false,
                expands: false,
                minLines: 5,
                maxLines: null,
                cursorColor: _theme.accentColor,
                onChanged:(text){
                  if(text.length<rawText.length){
                    //这部分用于处理删除表情的逻辑
                    var endIndex=_controller.selection.baseOffset;
                    if(rawText.substring(endIndex,endIndex+1)==']'){
                      var head=rawText.substring(0,_controller.selection.baseOffset);
                      var end=rawText.substring(_controller.selection.baseOffset+1);
                      var startIndex=head.lastIndexOf('[');
                      var emotionText=rawText.substring(startIndex,endIndex+1);
                      if(endIndex>startIndex&&(endIndex-startIndex<12)&&EmotionProvider.getEmotion(emotionText).success){
                        head=rawText.substring(0,startIndex);
                        _controller.text=head+end;
                        _controller.selection=TextSelection.fromPosition(TextPosition(offset: startIndex));
                        rawText=_controller.text;
                        return;
                      }
                    }
                  }
                  rawText=text;
                },
                textInputAction: TextInputAction.done,
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(4),
              sliver: SliverGrid.count(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                children:autoAddButtonToGrid(imageGridList),
              ),
            ),
          ],
      ),

      //底部工具栏
      bottomNavigationBar: Container(
        height: (!isEmotionPanelShow&&!isKeyboardShow)?48:48+emotionPanelHeight,
        color:_theme.dialogBackgroundColor,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                Row(
                  children: <Widget>[
                    //图片
                    CustomButton(
                      height: 48,width: 48,
                      child: Icon(Icons.image,color: _theme.primaryColor,),
                      padding: EdgeInsets.all(0),
                      shape: Border(),
                      onTap: openPhotoGallery,
                      color: Colors.transparent,
                    ),
                    //@
                    CustomButton(
                      height: 48,width: 48,
                      child: Icon(Icons.alternate_email,color: _theme.primaryColor,),
                      padding: EdgeInsets.all(0),
                      shape: Border(),
                      onTap: (){
                        var text=_controller.text;
                        var textHead=text.substring(0,_controller.selection.baseOffset)+'@ ';
                        _controller.text=textHead+text.substring(_controller.selection.baseOffset);
                        _controller.selection=TextSelection.fromPosition(TextPosition(offset: textHead.length-1));
                        rawText=_controller.text;
                      },
                      color: Colors.transparent,
                    ),
                    //话题
                    CustomButton(
                      height: 48,width: 48,
                      child: Icon(const IconData(0x0023),color: _theme.primaryColor,),
                      padding: EdgeInsets.all(0),
                      shape: Border(),
                      onTap: (){
                        var text=_controller.text;
                        var textHead=text.substring(0,_controller.selection.baseOffset)+'##';
                        _controller.text=textHead+text.substring(_controller.selection.baseOffset);
                        _controller.selection=TextSelection.fromPosition(TextPosition(offset: textHead.length-1));
                        rawText=_controller.text;
                      },
                      color: Colors.transparent,
                    ),
                    //表情
                    CustomButton(
                      height: 48,width: 48,
                      child: Icon(isKeyboardShow?Icons.tag_faces:Icons.keyboard,color: _theme.primaryColor,),
                      padding: EdgeInsets.all(0),
                      shape: Border(),
                      onTap: (){
                        setState(() {
                          if(isKeyboardShow){
                            SystemChannels.textInput.invokeMethod('TextInput.hide');
                            isEmotionPanelShow=true;
                            isKeyboardShow=false;
                          }else{
                            isEmotionPanelShow=false;
                            isKeyboardShow=true;
                            SystemChannels.textInput.invokeMethod('TextInput.show');
                            // _textFieldNode.unfocus();
                            // _textFieldNode.requestFocus();
                          }
                        });
                        
                      },
                      color: Colors.transparent,
                    ),
                  ]
                ),
                //发送按键
                CustomButton(
                  height: 48,width: 48,
                  child: Icon(Icons.send,color: _theme.primaryColor,),
                  padding: EdgeInsets.all(0),
                  shape: Border(),
                  onTap: () async {
                    
                    var sendText=rawText;
                    if(sendText==null||sendText.isEmpty){
                      if(assetList!=null) sendText='分享图片';
                      else{
                        toast('请填写微博内容');
                        return;
                      }
                    }
                    Navigator.pop(context);
                    var success=await WeiboApi.postWeibo(sendText,picList: assetList);
                    if(success){
                      toast('发布成功');
                    }
                  },
                  color: Colors.transparent,
                ),
              ],
            ),
            //表情面板
            Offstage(
              offstage: !isEmotionPanelShow,
              child:Container(
                height:emotionPanelHeight,
                child: EmotionPanel(
                  onEmotionButtonTap: (emotionName){
                    var text=_controller.text;
                    var textHead=text.substring(0,_controller.selection.baseOffset)+emotionName;
                    _controller.text=textHead+text.substring(_controller.selection.baseOffset);
                    _controller.selection=TextSelection.fromPosition(TextPosition(offset: textHead.length));
                    rawText=_controller.text;
                  },
                ),
              ),
              
            )
          ],
        ),
      ),
      // resizeToAvoidBottomInset: true,
    );
  }
  // void changeKeyboardState(){    
  //   //isResizeToAvoidBottomInset=!isResizeToAvoidBottomInset;
  //   isKeyboardShow?SystemChannels.textInput.invokeMethod('TextInput.hide'):_textFieldNode.requestFocus();
  // }
  Future<void> openPhotoGallery() async {
    //在安卓10上打不开系统相机，待解决
    var _theme=Theme.of(context);
    if(imageGridList.length>=9) return;
    try{
      assetList=await MultiImagePicker.pickImages(
        maxImages: 9-imageGridList.length,
        enableCamera: true,
        materialOptions: MaterialOptions(
          allViewTitle:'全部图片',
          lightStatusBar:_theme.brightness==Brightness.dark,
          actionBarTitle: '已选择',
          selectionLimitReachedText: '已达上限',
          textOnNothingSelected: '没有选择图片',
          statusBarColor:  '#'+_theme.primaryColor.value.toRadixString(16),
          actionBarColor: '#'+_theme.primaryColor.value.toRadixString(16),
          actionBarTitleColor: '#'+_theme.primaryTextTheme.bodyText1.color.value.toRadixString(16)
        )
      );
      var data=await assetList[0].getByteData();
      print(data.lengthInBytes*data.elementSizeInBytes);
      var tumbList=assetList.map((asset){
        var tumb= AssetThumb(asset: asset,width: 100,height: 100);
        var _key=GlobalKey();
        return Stack(
          key: _key,
          fit: StackFit.expand,
          children: <Widget>[
            tumb,
            Stack(
              alignment: Alignment.topRight,
              children:<Widget>[
                Material(
                    color:Colors.white38,
                    child:InkWell(
                      child:Icon(Icons.close,color:Colors.white),
                      //删除已经选择的图片
                      onTap:(){
                        setState(() {
                          imageGridList.remove(_key.currentWidget);
                          assetList.remove(asset);
                        });
                      }
                    )
                  )
              ]
            )
          ]
        );
      });
      setState(() {
        imageGridList.addAll(tumbList);
      });
    }
    catch(e){
      if(e is NoImagesSelectedException) return;
      print('打开相册发生错误${e.toString()}');
    }finally{
      // _textFieldNode.requestFocus();
      // SystemChannels.textInput.invokeMethod('TextInput.show');
    }
  }

  List<Widget> autoAddButtonToGrid(List<Widget> sourceList){
    if(sourceList.length==0) return <Widget>[];
    var returnList=sourceList.toList();
    if(returnList.length<9) {
      returnList.add(
        Material(
          child:InkWell(
            child: Icon(Icons.add,color: Colors.grey[400],),
            onTap: openPhotoGallery,
          ),
          color:Colors.grey[300],
        )
      );
    }
    return returnList;
  }
  void toast(String str){
    Fluttertoast.showToast(
      msg: str,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
    );
  }
}
