import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../model/weibo.dart';
import '../show_image_view.dart';
//单条微博显示的图片部分

class WeiboImageWidget extends StatelessWidget {
  final Weibo weibo;
  const WeiboImageWidget(this.weibo);

  @override
  Widget build(BuildContext context) {

    return Container(
      child: new Wrap(
        children: buildImagesWidget(context, weibo),
        spacing: 5.0,
        runSpacing: 5.0,
      ),
    );
  }
}
List<Widget> buildImagesWidget(context,weibo){
  var imgList=<Widget>[];
  if(weibo.picUrls.length==1){
    final imgProvider=CachedNetworkImageProvider(weibo.picUrls[0].thumbnailPic.replaceFirst(RegExp('thumbnail'), 'bmiddle'));

    double imgWidth,imgHeight;
    imgProvider.resolve(ImageConfiguration()).addListener(ImageStreamListener((ImageInfo info,bool _){
      imgWidth=info.image.width.toDouble();
      imgHeight=info.image.height.toDouble();
      var image;
      if((imgWidth/imgHeight)<0.42){
        image=Image(image:imgProvider,fit: BoxFit.cover,width: 200,);
      }else{
        image=Image(image:imgProvider,fit: BoxFit.cover);
      }
      imgList.add(
        GestureDetector(
          child:LimitedBox(
            child:image,
            maxHeight: 300,
          ),
          onTap: (){
            weiboImageWidgetItemOnTap(context,weibo.picUrls);
          },
        ),
      );
    }));

  }else{
    var regex=RegExp('thumbnail');
    for(var i=0;i<weibo.picUrls.length;i++){
      var imgUrl= weibo.picUrls[i].thumbnailPic.replaceFirst(regex, 'bmiddle');
      imgList.add(
        GestureDetector(
          child:SizedBox(
            child:Image(
              image: CachedNetworkImageProvider(imgUrl),
              fit: BoxFit.cover,
            ),
            width: 119,
            height: 119,   
          ),
          onTap: (){
            weiboImageWidgetItemOnTap(context,weibo.picUrls,index: i);
          },
        )
      );
    }
  }
  return imgList;
}
weiboImageWidgetItemOnTap(context,List<PicUrls> picUrls,{int index=0}){
  // var photoViewList=<PhotoViewGalleryPageOptions>[];
  // var regex=RegExp('thumbnail');
  var urls=<String>[];
  for(var i=0;i<picUrls.length;i++){
    var picUrl=picUrls[i];
    // var _scaleStateController=PhotoViewScaleStateController();
    // _scaleStateController.scaleState=PhotoViewScaleState.covering;
    // photoViewList.add(
    //   PhotoViewGalleryPageOptions(
    //     imageProvider: CachedNetworkImageProvider(picUrl.thumbnailPic.replaceFirst(regex, 'large')),
    //   )
    // );
    urls.add(picUrl.thumbnailPic);
  }
  Navigator.push(context,MaterialPageRoute(builder:(context)=>ShowImagesView(urls,currentIndex: index,)));
}


