import 'package:cookiej/cookiej/page/widget/custom_button.dart';
import 'package:cookiej/cookiej/provider/emotion_provider.dart';
import 'package:flutter/material.dart';


typedef ButtonOnTap<T> = void Function(T value);

class EmotionPanel extends StatefulWidget {
  
  final ButtonOnTap<String> onEmotionButtonTap;

  const EmotionPanel({Key key, this.onEmotionButtonTap}) : super(key: key);

  @override
  _EmotionPanelState createState() => _EmotionPanelState();
}

class _EmotionPanelState extends State<EmotionPanel> with TickerProviderStateMixin {

  //显示emotion的Grid，获取方式为该组件从emotionProvider中获得，非传入
  final _emotionGroup=EmotionProvider.getEmotionGroup();
  TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController=TabController(length: _emotionGroup?.data?.length??0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column( 
      children:[
        Expanded(child:TabBarView(
          controller: _tabController,
          children: (){
            var childList=<Widget>[];
            if(_emotionGroup.success){
              _emotionGroup.data.keys.forEach((groupName){
                childList.add(
                  GridView.extent(
                    shrinkWrap: true,
                    maxCrossAxisExtent: 64,
                    children: _emotionGroup.data[groupName].map((emotion){
                      return CustomButton(
                        child: Image(image: emotion.imageProvider,fit:BoxFit.fill),
                        padding: EdgeInsets.all(8),
                        shape: Border(),
                        onTap: (){
                          print('按下了${emotion.phrase}');
                          widget.onEmotionButtonTap(emotion.phrase);
                        },
                        color: Colors.transparent,
                      );
                    }).toList(),
                  )
                );
              });
            }
            return childList;
          }()
        ),
        ),
        TabBar(
          tabs: !_emotionGroup.success?[]
          :_emotionGroup.data.keys.map((groupName)=>Padding(
            padding: EdgeInsets.symmetric(horizontal:8,vertical:6),
            child: Text(groupName.isEmpty?'默认':groupName),
          )).toList(),
          controller: _tabController,
          isScrollable: true,
          labelPadding: EdgeInsets.zero,
          labelColor: Theme.of(context).primaryTextTheme.bodyText2.color,
          unselectedLabelColor: Theme.of(context).textTheme.bodyText2.color,
        )
      ]
    );
  }
}