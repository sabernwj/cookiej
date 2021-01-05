import 'dart:io';

import 'package:cookiej/app/config/config.dart';
import 'package:cookiej/app/service/repository/picture_repository.dart';
import 'package:cookiej/app/views/components/base/show_image_view.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class ImageSetWidget extends StatelessWidget {

  final List<String> imgUrls;
  final String sinaImgSize;
  final String heroTag;

  const ImageSetWidget({Key key,@required this.imgUrls, this.sinaImgSize=SinaImgSize.bmiddle,this.heroTag=''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var imgWidth = (MediaQuery.of(context).size.width - 32) / 3;

    var imgOnTap =
        (BuildContext context, List<String> imgUrls, {int index = 0}) {
      //Navigator.push(context,MaterialPageRoute(builder:(context)=>ShowImagesView(imgUrls,currentIndex: index,)));
      Navigator.push(
        context,
        Platform.isAndroid
            ? TransparentMaterialPageRoute(
            builder: (_) => ShowImagesView(
              imgUrls,
              currentIndex: index,
              heroTag: heroTag,
            ))
            : TransparentMaterialPageRoute(
            builder: (_) => ShowImagesView(
              imgUrls,
              currentIndex: index,
              heroTag: heroTag,
            )),
      );
    };
    if (imgUrls.length == 1) {
      return GestureDetector(
          child: ConstrainedBox(
            child: Padding(
              child: Hero(
                tag: imgUrls[0] + heroTag,
                child: Image(
                    image: PictureRepository.getPictureFromUrl(imgUrls[0],
                        sinaImgSize: sinaImgSize),
                    fit: BoxFit.cover),
              ),
              padding: EdgeInsets.only(bottom: 6),
            ),
            constraints:
            BoxConstraints(maxHeight: imgWidth * 1.5, minWidth: imgWidth),
          ),
          onTap: () {
            imgOnTap(context, imgUrls);
          });
    } else if (imgUrls.length > 1) {
      var imgWidgetList = <Widget>[];
      for (var i = 0; i < imgUrls.length; i++) {
        imgWidgetList.add(GestureDetector(
          child: Hero(
            tag: imgUrls[i] + heroTag,
            child: Image(
                image: PictureRepository.getPictureFromUrl(imgUrls[i],
                    sinaImgSize: sinaImgSize),
                fit: BoxFit.cover),
          ),
          onTap: () {
            imgOnTap(context, imgUrls, index: i);
          },
        ));
      }
      return GridView.count(
        crossAxisCount: imgUrls.length <= 4 ? 2 : 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: imgWidgetList,
      );
    }
    return Container();
  }
}
