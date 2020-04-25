import 'package:cookiej/cookiej/model/emotion.dart';
import 'package:cookiej/cookiej/page/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:cookiej/cookiej/page/widget/emotion_panel.dart';
import 'package:multi_image_picker/multi_image_picker.dart';


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
  ///用于准备向发送接口输入的文本 
  String rawText='';

  @override
  void initState(){
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
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
              child: TextField(
                focusNode: _textFieldNode,
                autofocus: true,
                autocorrect: false,
                expands: false,
                minLines: 5,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none
                ),
                cursorColor: _theme.accentColor,
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
                      onTap: (){},
                      color: Colors.transparent,
                    ),
                    //话题
                    CustomButton(
                      height: 48,width: 48,
                      child: Icon(IconData(0x0023),color: _theme.primaryColor,),
                      padding: EdgeInsets.all(0),
                      shape: Border(),
                      onTap: (){},
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
                            _textFieldNode.unfocus();
                            _textFieldNode.requestFocus();
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
                  onTap: (){},
                  color: Colors.transparent,
                ),
              ],
            ),
            //表情面板
            Offstage(
              offstage: !isEmotionPanelShow,
              child:Container(
                height:emotionPanelHeight,
                child: EmotionPanel(),
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
  void openPhotoGallery(){
    //在安卓10上打不开系统相机，待解决
    var _theme=Theme.of(context);
    if(imageGridList.length>=9) return;

    MultiImagePicker.pickImages(
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
        actionBarTitleColor: '#'+_theme.primaryTextTheme.body2.color.value.toRadixString(16)
      )
    ).then((assetList){
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
    }).catchError((e)=>print('打开相册发生错误${e.toString()}'));
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
}
