import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'weibo.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'weibo_image_view.dart';
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
  if(weibo.pic_urls.length==1){
    final imgProvider=CachedNetworkImageProvider(weibo.pic_urls[0].thumbnail_pic.replaceFirst(RegExp('thumbnail'), 'bmiddle'));

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
            weiboImageWidgetItemOnTap(context,weibo.pic_urls);
          },
        ),
      );
    }));

  }else{
    var regex=RegExp('thumbnail');
    for(var i=0;i<weibo.pic_urls.length;i++){
      var imgUrl= weibo.pic_urls[i].thumbnail_pic.replaceFirst(regex, 'bmiddle');
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
            weiboImageWidgetItemOnTap(context,weibo.pic_urls,index: i);
          },
        )
      );
    }
  }
  return imgList;
}
weiboImageWidgetItemOnTap(context,List<PicUrl> picUrls,{int index=0}){
  var photoViewList=<PhotoViewGalleryPageOptions>[];
  var regex=RegExp('thumbnail');
  for(var i=0;i<picUrls.length;i++){
    var picUrl=picUrls[i];
    var _scaleStateController=PhotoViewScaleStateController();
    _scaleStateController.scaleState=PhotoViewScaleState.covering;
    photoViewList.add(
      PhotoViewGalleryPageOptions(
        imageProvider: CachedNetworkImageProvider(picUrl.thumbnail_pic.replaceFirst(regex, 'large')),
        // scaleStateController: _scaleStateController,
        // basePosition: Alignment.topLeft
        // heroTag: "$i",
      )
    );
  }
  Navigator.push(context,MaterialPageRoute(builder:(context)=>ImagesView(photoViewList,currentIndex: index,)));
}


