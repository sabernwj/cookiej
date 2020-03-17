import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/page/widget/show_image_view.dart';
import 'package:cookiej/cookiej/provider/picture_provider.dart';
import 'package:flutter/material.dart';

///自适应的图片显示组件
class ContentPictureFlow extends StatelessWidget {

  final List<String> _picUrls;

  ContentPictureFlow(this._picUrls);

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: _Delegate(),
      children: getPictureWidgetFromUrls(context, _picUrls),
    );
  }

  List<Widget> getPictureWidgetFromUrls(BuildContext context, List<String> picUrls){
    var picWidgetList=<Widget>[];
    for(var i=0;i<picUrls.length;i++){
      picWidgetList.add(
        GestureDetector(
          child:SizedBox(
            child:Image(
              image: PictureProvider.getPictureFromUrl(picUrls[i],sinaImgSize: SinaImgSize.bmiddle),
              fit: BoxFit.cover,
            ),
            width: 120,
            height: 120,   
          ),
          onTap: (){
            Navigator.push(context,MaterialPageRoute(builder:(context)=>ShowImagesView(picUrls,currentIndex: i,)));
          },
        )
      );
    }
    return picWidgetList;
  }
}


class _Delegate extends FlowDelegate {

  double width;
  double height;
  Size size;

  @override
  void paintChildren(FlowPaintingContext context){
    //print(context.size);
    size=context.getChildSize(0);
    context.paintChild(0);
  }

  @override
  Size getSize(BoxConstraints constraints) {
    return Size(double.infinity,200);
  }

  @override
  bool shouldRepaint(FlowDelegate oldDelegate){
    return true;
  }
}