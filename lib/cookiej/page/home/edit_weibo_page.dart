import 'package:cookiej/cookiej/page/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:extended_text_field/extended_text_field.dart';

class EditWeiboPage extends StatefulWidget {
  @override
  _EditWeiboPageState createState() => _EditWeiboPageState();
}

class _EditWeiboPageState extends State<EditWeiboPage> {
  bool _isBottomEmotionShow=false;

  @override
  Widget build(BuildContext context) {
    final _theme=Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title:Text('发微博')
      ),
      body: Container(
        child: TextField(
          autocorrect: false,
          expands: true,
          minLines: null,
          maxLines: null,
        )
      ),
      //底部工具栏
      bottomSheet: Container(
        height:48,
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
                      child: Icon(Icons.tag_faces,color: _theme.primaryColor,),
                      padding: EdgeInsets.all(0),
                      shape: Border(),
                      onTap: (){
                        setState(() {
                          _isBottomEmotionShow=true;
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
            Offstage(
              offstage: !_isBottomEmotionShow,
              child: Container(
                height: 200,
                color:Colors.green
              ),
            )
          ],
        ),
      ),
    );
  }
}