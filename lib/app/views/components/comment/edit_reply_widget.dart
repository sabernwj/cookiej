import 'package:cookiej/app/model/local/edit_special_text.dart';
import 'package:cookiej/app/service/repository/emotion_repository.dart';
import 'package:cookiej/app/views/components/base/custom_button.dart';
import 'package:cookiej/app/views/components/base/emotion_panel.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class EditReplyWidget extends StatefulWidget {
  final String hintText;
  final Future<bool> Function(String) sendCall;

  const EditReplyWidget({Key key,this.hintText, this.sendCall}) : super(key: key);

  @override
  _EditReplyWidgetState createState() => _EditReplyWidgetState();
}

class _EditReplyWidgetState extends State<EditReplyWidget> {

  final FocusNode _textFieldNode=FocusNode();
  TextEditingController _controller=TextEditingController();
  ///用于准备向发送接口输入的文本
  String rawText='';
  bool isEmotionPanelShow=false;
  bool isKeyboardShow=true;
  double emotionPanelHeight=0;
  double keyboardHeight=0;
  List<Asset> assetList;
  List<Widget> imageGridList=List();

  @override
  void initState() {
    super.initState();
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
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom:4),
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
                  hintText: widget.hintText??'写点什么...'
              ),
              autofocus: true,
              autocorrect: false,
              expands: false,
              maxLines: null,
              maxLength: 140,
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
                    if(endIndex>startIndex&&(endIndex-startIndex<12)&&EmotionRepository.getEmotion(emotionText)!=null){
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
          //图片
          //工具栏
          Container(
            height: (!isEmotionPanelShow&&!isKeyboardShow)?48:48+emotionPanelHeight,
            color:_theme.dialogBackgroundColor,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    Row(
                        children: <Widget>[
                          //图片（发表图片评论暂时被禁用了）
                          // CustomButton(
                          //   height: 48,width: 48,
                          //   child: Icon(Icons.image,color: _theme.primaryColor,),
                          //   padding: EdgeInsets.all(0),
                          //   shape: Border(),
                          //   onTap: openPhotoGallery,
                          //   color: Colors.transparent,
                          // ),
                          //@
                          CustomButton(
                            height: 48,width: 48,
                            child: Icon(Icons.alternate_email,color: _theme.primaryTextTheme.bodyText2.color),
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
                            child: Icon(const IconData(0x0023), color: _theme.primaryTextTheme.bodyText2.color),
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
                            child: Icon(isKeyboardShow?Icons.tag_faces:Icons.keyboard,color: _theme.primaryTextTheme.bodyText2.color),
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
                      child: Icon(Icons.send,color: _theme.primaryTextTheme.bodyText2.color),
                      padding: EdgeInsets.all(0),
                      shape: Border(),
                      onTap: () async {
                        bool canPop=false;
                        canPop=await widget.sendCall(rawText);
                        if(canPop) Get.back();
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
          )
        ],
      ),
    );
  }

  Future<void> openPhotoGallery() async {
    //在安卓10上打不开系统相机，待解决
    var _theme=Theme.of(context);
    try{
      assetList=await MultiImagePicker.pickImages(
          maxImages: 1,
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
        var tumb= AssetThumb(asset: asset,width: 48,height: 48);
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
    }
  }
}