import 'package:flutter/material.dart';
import 'weibo.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
//单条微博显示的图片部分



class WeiboImageWidget extends StatelessWidget {
  final Weibo weibo;
  const WeiboImageWidget(this.weibo);
  @override
  Widget build(BuildContext context) {
    weiboImageWidgetItemOnTap(List<PicUrl> picUrls,{int index=0}){
      var photoViewList=<PhotoViewGalleryPageOptions>[];
      var regex=RegExp('thumbnail');
      for(var i=0;i<picUrls.length;i++){
        var picUrl=picUrls[i];
        photoViewList.add(
          PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(picUrl.thumbnail_pic.replaceFirst(regex, 'large')),
            heroTag: "$i"
          )
        );
      }
      Navigator.push(context,MaterialPageRoute(builder:(context)=>ImagesView(photoViewList,currentIndex: index,)));
    }
    return Container(
      child: new Wrap(
        children: (){
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
                  weiboImageWidgetItemOnTap(weibo.pic_urls);
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
                    width: 168,
                    height: 168,
                  ),
                  onTap: (){
                    weiboImageWidgetItemOnTap(weibo.pic_urls,index: i);
                  },
                )
              );
            }
          }
          return imgList;
        }(),
        spacing: 5.0,
        runSpacing: 5.0,
      ),
    );
  }
}

class ImagesView extends StatefulWidget {
  final List<PhotoViewGalleryPageOptions> imageList;
  final int currentIndex;
  final PageController pageController;
  ImagesView(
    this.imageList,
    {
      this.currentIndex=0
    }
  ):pageController=PageController(initialPage: currentIndex);
  @override
  _ImagesViewState createState() => _ImagesViewState();
}

class _ImagesViewState extends State<ImagesView> {
  int currentIndex;
  @override
  void initState(){
    currentIndex=widget.currentIndex;
    super.initState();
  }
  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Material(
      child: Container(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            PhotoViewGallery(
              pageOptions: widget.imageList,
              backgroundDecoration: BoxDecoration(color: Colors.black87),
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "${currentIndex + 1}/${widget.imageList.length}",
                style: const TextStyle(
                    color: Colors.white70, fontSize: 20, decoration: null),
              ),
            )
          ],
        ),
      ),
    );
  }
}

