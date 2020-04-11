import 'package:cookiej/cookiej/page/widget/custom_button.dart';
import 'package:flutter/material.dart';
//import 'package:keyboard_visibility/keyboard_visibility.dart';


class EditWeiboPage extends StatefulWidget {
  @override
  _EditWeiboPageState createState() => _EditWeiboPageState();
}

class _EditWeiboPageState extends State<EditWeiboPage> {

  final FocusNode _textFieldNode=FocusNode();
  double keyboardHeight=0;
  double emotionPanelHeight=0;
  bool isResizeToAvoidBottomInset=true;
  bool isKeyboardShow=true;


  @override
  void initState(){
    super.initState();
    _textFieldNode.addListener((){
      var height= MediaQuery.of(context).viewInsets.bottom;
      setState(() {
        isKeyboardShow=height==0;
      });
    });
    // KeyboardVisibilityNotification().addNewListener(
    //   onChange: (bool visible) {
    //     print(visible.toString()+'7777777777');
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    final _theme=Theme.of(context);
    keyboardHeight=MediaQuery.of(context).viewInsets.bottom;
    if(keyboardHeight>0){
      isResizeToAvoidBottomInset=false;
      emotionPanelHeight=keyboardHeight;
    }
    return Scaffold(
      appBar: AppBar(
        title:Text('发微博')
      ),
      body: Container(
        child: TextField(
          focusNode: _textFieldNode,
          autofocus: true,
          autocorrect: false,
          expands: true,
          minLines: null,
          maxLines: null,
        )
      ),
      //底部工具栏
      bottomSheet: Container(
        height:48+emotionPanelHeight,
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
                      onTap: (){},
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
                          var height=MediaQuery.of(context).viewInsets.bottom;
                          if(height==0) _textFieldNode.unfocus();
                          changeKeyboardState();
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
            Container(
              height:emotionPanelHeight,
              color:Colors.green
            )
          ],
        ),
      ),
      resizeToAvoidBottomInset: isResizeToAvoidBottomInset,
    );
  }
  void changeKeyboardState(){
    //isKeyboardShow=!isKeyboardShow;
    isResizeToAvoidBottomInset=!isResizeToAvoidBottomInset;
    _textFieldNode.hasFocus?_textFieldNode.unfocus():_textFieldNode.requestFocus();
  }
}

enum _ShowType{
  Emotions,
  Keyboard
}