import 'package:cookiej/cookiej/config/config.dart';
import 'package:cookiej/cookiej/provider/picture_provider.dart';
import 'package:cookiej/cookiej/utils/utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
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

class _ShowImagesViewState extends State<ShowImagesView>  with TickerProviderStateMixin{
  int currentIndex;
  bool isInPop=false;

  AnimationController _doubleClickAnimationController;
  Animation<double> _doubleClickAnimation;
  Function _doubleClickAnimationListener;
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

    _doubleClickAnimationController = AnimationController(
        duration: const Duration(milliseconds: 150), vsync: this);
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
      physics: BouncingScrollPhysics(),
      itemCount: widget.imgUrls.length,
      itemBuilder: (context,index){
        var item=widget.imgUrls[index];
        Size rawImageSize;
        bool isLongPicture=false;
        Widget image = ExtendedImage(
          image: PictureProvider.getPictureFromUrl(item,sinaImgSize:SinaImgSize.large),
          fit: BoxFit.contain,
          enableSlideOutPage: true,
          mode: ExtendedImageMode.gesture,
          initGestureConfigHandler:(state){
            rawImageSize=Size(state.extendedImageInfo.image.width.toDouble(), state.extendedImageInfo.image.height.toDouble());
            if((rawImageSize.width/rawImageSize.height)<(9/21)) isLongPicture=true;

            double scaleWithScreen=MediaQuery.of(context).size.height/((rawImageSize.height/rawImageSize.width)*MediaQuery.of(context).size.width);
            double realScale=rawImageSize.width/MediaQuery.of(context).size.width;
            return GestureConfig(
              minScale: 1.0,
              maxScale: math.max(scaleWithScreen,realScale),
              inPageView: true,
            );
          },
          onDoubleTap: (state){
            double begin = state.gestureDetails.totalScale;
            double scaleWithScreen=MediaQuery.of(context).size.height/((rawImageSize.height/rawImageSize.width)*MediaQuery.of(context).size.width);
            double realScale=rawImageSize.width/MediaQuery.of(context).size.width;
            double end=begin;
            bool needRealScale=realScale>scaleWithScreen;
            Offset pointerDownPosition = isLongPicture?Offset.zero:state.pointerDownPosition;
            if(isLongPicture) {
              needRealScale=false;
              scaleWithScreen=MediaQuery.of(context).size.width/((rawImageSize.width/rawImageSize.height)*MediaQuery.of(context).size.height);
            }
            if(needRealScale){
              if(begin<scaleWithScreen){
                end=scaleWithScreen;
              }else if(begin>=scaleWithScreen && begin<realScale){
                end=realScale+0.01;
              }else if(begin>=realScale){
                end=1.0;
              }
            }else{
              if(begin<scaleWithScreen){
                end=scaleWithScreen;
              }else if(begin>=scaleWithScreen){
                end=1.0;
              }
            }
            //remove old
            _doubleClickAnimation
                ?.removeListener(_doubleClickAnimationListener);

            //stop pre
            _doubleClickAnimationController.stop();

            //reset to use
            _doubleClickAnimationController.reset();

            _doubleClickAnimationListener = () {
              //print(_animation.value);
              state.handleDoubleTap(
                scale: _doubleClickAnimation.value,
                doubleTapPosition: pointerDownPosition
              );
            };
            _doubleClickAnimation = _doubleClickAnimationController
                .drive(Tween<double>(begin: begin, end: end));

            _doubleClickAnimation
                .addListener(_doubleClickAnimationListener);

            _doubleClickAnimationController.forward();
          },
          heroBuilderForSlidingPage: (result){
            if (index == currentIndex) {
              return Hero(
                tag: item,
                child: result,
                flightShuttleBuilder: (BuildContext flightContext,
                    Animation<double> animation,
                    HeroFlightDirection flightDirection,
                    BuildContext fromHeroContext,
                    BuildContext toHeroContext) {
                  final Hero hero =
                      flightDirection == HeroFlightDirection.pop
                          ? fromHeroContext.widget
                          : toHeroContext.widget;
                  return hero.child;
                },
              );
            } else {
              return result;
            }
          },
        );
        return image;
      },
      onPageChanged: (int index) {
        setState(() {
          currentIndex = index;
        });
      },
      canMovePage: (gestureDetails){
        if(gestureDetails.totalScale>1.0){
          return false;
        }
        else return  true;
      },
      controller: PageController(
        initialPage: currentIndex,
      ),
      scrollDirection: Axis.horizontal,
    );
    
    Widget returnWidget=ExtendedImageSlidePage(
      slideAxis: SlideAxis.both,
      slideType: SlideType.onlyImage,
      child:Material(
        color:Colors.transparent,
        shadowColor: Colors.transparent,
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            showWidget,
            Positioned(
              bottom: 30,
              child: Text(
                "${currentIndex + 1}/${widget.imgUrls.length}",
                style: Theme.of(context).primaryTextTheme.bodyText1,
              ),
            )
          ],
        )
      ),
      slidePageBackgroundHandler: (offset,size){
        Color color=Colors.black;
        double opacity = 0.0;
        opacity = offset.distance / (Offset(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height).distance / 2.0);
        return color.withOpacity(math.min(1.0, math.max(1.0 - opacity, 0.0)));
      },
      slideOffsetHandler: (offset,{state}){
        if (state != null &&
            state.imageGestureState.gestureDetails.totalScale > 1.0) {
          return Offset.zero;
        }
        return null;
      },
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