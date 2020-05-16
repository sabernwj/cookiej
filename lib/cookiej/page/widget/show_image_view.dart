import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/provider/picture_provider.dart';
import 'package:cookiej/cookiej/utils/utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';

///封装好，全屏查看一批图片的组件
class ShowImagesView extends StatefulWidget {
  //final imageList;
  final List<String> imgUrls;
  final int currentIndex;
  final PageController pageController;
  ShowImagesView(
    this.imgUrls,
    {
      this.currentIndex=0
    }
  ):pageController=PageController(initialPage: currentIndex);//imageList=<PhotoViewGalleryPageOptions>[];
  @override
  _ShowImagesViewState createState() => _ShowImagesViewState();
}

class _ShowImagesViewState extends State<ShowImagesView> {
  int currentIndex;
  bool isInPop=false;

  @override
  void initState(){
    // widget.imgUlrs.forEach((url){
    //   widget.imageList.add(PhotoViewGalleryPageOptions(
    //     maxScale: 2.0,
    //     //imageProvider: PictureProvider.getPictureFromId(Utils.getImgIdFromUrl(url),sinaImgSize: SinaImgSize.large),
    //     imageProvider: PictureProvider.getPictureFromUrl(url,sinaImgSize:SinaImgSize.large)
    //   ));
    // });
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
    Widget showWidget;
    showWidget=isInPop?
    Center(
      child:Hero(
        tag: widget.imgUrls[widget.currentIndex],
        child:Image(image: PictureProvider.getPictureFromUrl(widget.imgUrls[widget.currentIndex],sinaImgSize:SinaImgSize.bmiddle))
      )
    )
    :ExtendedImageGesturePageView.builder(
      itemCount: widget.imgUrls.length,
      itemBuilder: (context,index){
        var item=widget.imgUrls[index];
        Widget image = ExtendedImage(
          image: PictureProvider.getPictureFromUrl(item,sinaImgSize:SinaImgSize.large),
          fit: BoxFit.fitWidth,
          mode: ExtendedImageMode.gesture,
          initGestureConfigHandler:(state){
            // state.imageProvider.resolve((ImageConfiguration())).addListener(ImageStreamListener((ImageInfo info, bool _){
              
            // }));
            return GestureConfig(
              minScale: 1.0,
              maxScale: 4.0
            );
          },
          onDoubleTap: (state){

          },
        );
        
        image = Container(
          child: image,
        );
        if (index == currentIndex) {
          return Hero(
            tag: item,
            child: image,
          );
        } else {
          return image;
        }
      },
      onPageChanged: (int index) {
        setState(() {
          currentIndex = index;
        });
      },
      
      controller: PageController(
        initialPage: currentIndex,
      ),
      scrollDirection: Axis.horizontal,
    );
    
    Widget returnWidget=Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          showWidget,
          //
          Container(
            padding: const EdgeInsets.all(30.0),
            child: Text(
              "${currentIndex + 1}/${widget.imgUrls.length}",
              style: Theme.of(context).primaryTextTheme.bodyText1,
            ),
          )
        ],
      ),
    );
    returnWidget=WillPopScope(
      child: returnWidget, 
      onWillPop: () async{
        setState(() {
          isInPop=true;
        });
        return isInPop;
      }
    );
    return returnWidget;
    // return Container(
    //   child: Stack(
    //     alignment: Alignment.bottomCenter,
    //     children: <Widget>[
    //       PhotoViewGallery(
    //         pageOptions: widget.imageList,
    //         loadingChild: Container(
    //           child: Center(
    //             child: CircularProgressIndicator(),
    //           ),
    //           decoration: BoxDecoration(color: Colors.black87),
    //         ),
    //         backgroundDecoration: BoxDecoration(color: Colors.black87),
    //         pageController: widget.pageController,
    //         onPageChanged: onPageChanged,
    //       ),
    //       Container(
    //         padding: const EdgeInsets.all(30.0),
    //         child: Text(
    //           "${currentIndex + 1}/${widget.imageList.length}",
    //           style: const TextStyle(
    //               color: Colors.white70, fontSize: 18, decoration: null),
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }
}