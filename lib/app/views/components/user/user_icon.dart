import 'package:cookiej/app/model/user_lite.dart';
import 'package:cookiej/app/service/repository/picture_repository.dart';
import 'package:flutter/material.dart';

class UserIcon extends StatelessWidget {
  final UserLite user;
  final String screenName;
  final ImageProvider img;

  const UserIcon(this.img, {Key key, this.screenName, this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: CircleAvatar(
          backgroundImage:
              img ?? PictureRepository.getPictureFromId(user?.iconId),
          radius: 20),
      onTap: () {},
    );
  }

  /// 导航至对应用户页面
  void navigatorToUserPage(String screenName) {}
}
