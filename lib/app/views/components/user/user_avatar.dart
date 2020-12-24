import 'package:cookiej/app/model/local/user_lite.dart';
import 'package:cookiej/app/service/repository/picture_repository.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final UserLite user;
  final String screenName;
  final ImageProvider img;
  final UserAvatarShape shape;

  const UserAvatar(
      {Key key,
      this.img,
      this.screenName,
      this.user,
      this.shape = UserAvatarShape.Circle})
      : assert(user != null || (screenName != null && img != null)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var shapeMap = {
      UserAvatarShape.Circle: BoxShape.circle,
      UserAvatarShape.RectAngle: BoxShape.rectangle,
      UserAvatarShape.RoundedRectAngle: BoxShape.rectangle
    };

    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: img ?? PictureRepository.getPictureFromId(user?.iconId),
              fit: BoxFit.cover,
            ),
            shape: shapeMap[shape],
            borderRadius: shape == UserAvatarShape.RoundedRectAngle
                ? BorderRadius.circular(12)
                : null),
      ),
      onTap: () {},
    );
  }

  /// 导航至对应用户页面
  void navigatorToUserPage(String screenName) {}
}

enum UserAvatarShape {
  /// 圆形
  Circle,

  /// 矩形
  RectAngle,

  /// 圆角矩形
  RoundedRectAngle
}
