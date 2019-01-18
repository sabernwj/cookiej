import 'package:flutter/material.dart';
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
    imgList.add(
      GestureDetector(
        child:LimitedBox(
          child:Image.network(
            weibo.pic_urls[0].thumbnail_pic.replaceFirst(RegExp('thumbnail'), 'bmiddle'),
          ),
          maxHeight: 300,
        ),
        onTap: (){
          weiboImageWidgetItemOnTap(context,weibo.pic_urls);
        },
      ),
    );
  }else{
    var regex=RegExp('thumbnail');
    for(var i=0;i<weibo.pic_urls.length;i++){
      var imgUrl= weibo.pic_urls[i].thumbnail_pic.replaceFirst(regex, 'bmiddle');
      imgList.add(
        GestureDetector(
          child:SizedBox(
            child:Image.network(
              imgUrl,
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
    photoViewList.add(
      PhotoViewGalleryPageOptions(
        imageProvider: NetworkImage(picUrl.thumbnail_pic.replaceFirst(regex, 'large')),
        heroTag: "$i",
      )
    );
  }
  Navigator.push(context,MaterialPageRoute(builder:(context)=>ImagesView(photoViewList,currentIndex: index,)));
}


