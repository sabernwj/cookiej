import 'package:cookiej/app/config/config.dart';
import 'package:cookiej/app/provider/global_view_model.dart';
import 'package:cookiej/app/service/repository/picture_repository.dart';
import 'package:cookiej/app/service/repository/style_repository.dart';
import 'package:cookiej/app/views/pages/login/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class PersonalPage extends StatelessWidget {
  final GlobalKey _displayUserNameKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalViewModel>(builder: (context, globalVM, _) {
      final _theme = globalVM.currentTheme;
      final user = globalVM.currentUser;
      var _isDarkMode = _theme.brightness == Brightness.dark;
      var iconUrl = PictureRepository.getImgUrlFromId(user.iconId);
      return Scaffold(
          appBar: AppBar(
            bottom: PreferredSize(
              child: Expanded(
                flex: 4,
                child: Column(children: [
                  Container(
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                            // onTap: ()=>Navigator.push(
                            //   context,
                            //   Platform.isAndroid
                            //       ? TransparentMaterialPageRoute(builder: (_) => ShowImagesView([iconUrl],))
                            //       : TransparentMaterialPageRoute(builder: (_) => ShowImagesView([iconUrl],))
                            // ),
                            child: Hero(
                          tag: iconUrl,
                          child: SizedBox(
                            child: ClipOval(
                              child: Image(
                                image: PictureRepository.getPictureFromUrl(
                                    iconUrl),
                              ),
                            ),
                            width: 64,
                            height: 64,
                          ),
                        )),
                        Expanded(
                          child: ListTile(
                            title: Row(children: [
                              Text(user.screenName,
                                  style: _theme.primaryTextTheme.subtitle1),
                              InkWell(
                                child: Icon(
                                    const IconData(0xf0d7,
                                        fontFamily: StyleFonts.iconFontFamily),
                                    color:
                                        _theme.primaryTextTheme.subtitle1.color,
                                    size: 24),
                                onTap: () async {
                                  final RenderBox textDescription =
                                      _displayUserNameKey.currentContext
                                          .findRenderObject();
                                  showMenu(
                                    context: _displayUserNameKey.currentContext,
                                    position: RelativeRect.fromLTRB(
                                        textDescription
                                            .localToGlobal(Offset.zero)
                                            .dx,
                                        textDescription
                                            .localToGlobal(Offset.zero)
                                            .dy,
                                        100,
                                        0),
                                    items: await getLocalUsersItems(
                                        globalVM, context),
                                  );
                                },
                              )
                            ]),
                            subtitle: Text(
                                user.description.isEmpty
                                    ? '\u{3000}'
                                    : user.description,
                                key: _displayUserNameKey,
                                style: _theme.primaryTextTheme.subtitle2),
                            trailing: IconButton(
                                icon: Icon(
                                  const IconData(0xf105,
                                      fontFamily: StyleFonts.iconFontFamily),
                                  color:
                                      _theme.primaryTextTheme.subtitle1.color,
                                  size: 28,
                                ),
                                onPressed: () {
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //     builder: (context) => UserPage(
                                  //         inputUser: store.state.currentUser)));
                                }),
                          ),
                        )
                      ],
                    ),
                    margin: EdgeInsets.only(left: 14, bottom: 10),
                  ),
                  Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                        FlatButton(
                            onPressed: () {
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => UserPage(
                              //         inputUser: store.state.currentUser)));
                            },
                            child: Column(children: [
                              Text(user.statusesCount.toString(),
                                  style: _theme.primaryTextTheme.subtitle1),
                              Text('微博',
                                  style: _theme.primaryTextTheme.subtitle2)
                            ])),
                        FlatButton(
                            onPressed: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => UserListPage(
                              //             type: FriendShipsType.Friends,
                              //             screenName: user.screenName)));
                            },
                            child: Column(children: [
                              Text(user.friendsCount.toString(),
                                  style: _theme.primaryTextTheme.subtitle1),
                              Text('关注',
                                  style: _theme.primaryTextTheme.subtitle2)
                            ])),
                        FlatButton(
                            onPressed: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => UserListPage(
                              //             type: FriendShipsType.Followers,
                              //             screenName: user.screenName)));
                            },
                            child: Column(children: [
                              Text(user.followersCount.toString(),
                                  style: _theme.primaryTextTheme.subtitle1),
                              Text('粉丝',
                                  style: _theme.primaryTextTheme.subtitle2)
                            ])),
                      ]))
                ]),
              ),
              preferredSize: Size.fromHeight(128),
            ),
          ),
          //菜单
          body: Column(children: [
            Container(
              margin: EdgeInsets.only(top: 24, bottom: 0),
              child: Material(
                  color: _theme.dialogBackgroundColor,
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 4,
                    children: <Widget>[
                      _buildExpandedItem(
                          Icons.star, Colors.yellow[700], '收藏', _theme),
                      _buildExpandedItem(Icons.supervised_user_circle,
                          Colors.blue[400], '我的好友', _theme),
                      _buildExpandedItem(const IconData(0x23),
                          Colors.orange[700], '关注的话题', _theme),
                      _buildExpandedItem(FontAwesomeIcons.qrcode,
                          Colors.blue[400], '扫一扫', _theme,
                          size: 28),
                      _buildExpandedItem(
                          Icons.history, Colors.teal[300], '浏览历史', _theme),
                      _buildExpandedItem(FontAwesomeIcons.envelopeOpen,
                          Colors.purple, '草稿箱', _theme,
                          size: 23),
                      _buildExpandedItem(
                          Icons.location_on, Colors.red[400], '附近的微博', _theme),
                      _buildExpandedItem(
                          Icons.more_horiz, Colors.blueGrey, '更多', _theme),
                    ],
                  )),
            ),
            Container(
                margin: EdgeInsets.only(top: 24, bottom: 0),
                child: Ink(
                  color: _theme.dialogBackgroundColor,
                  child: Column(children: [
                    ListTile(
                      leading: Icon(Icons.wb_sunny),
                      title: Text('黑暗模式'),
                      trailing: CupertinoSwitch(
                        value: _isDarkMode,
                        activeColor: globalVM.currentTheme.primaryColor,
                        onChanged: (value) {
                          //存储夜间模式配置
                        },
                      ),
                      onTap: () {},
                    ),
                    Divider(
                      height: 1,
                    ),
                    ListTile(
                      leading: Icon(Icons.palette,
                          color: globalVM.currentTheme.primaryColor),
                      title: Text('主题样式'),
                      onTap: () {
                        //Navigator.push(context, MaterialPageRoute(builder: (context)=>ThemeStyle()));
                      },
                    ),
                    Divider(
                      height: 1,
                    ),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('更多设置'),
                      onTap: () async {},
                      // trailing: FutureBuilder(
                      //   future: Hive.lazyBox<Weibos>('weibos_box').get(store.state.accessState.currentAccess.uid).then((weibos)=>weibos.statuses.length.toString()),
                      //   builder: (context,snaphot)=>Text('已缓存数量${snaphot.data??'0'}',style: _theme.primaryTextTheme.overline)
                      // )
                    )
                  ]),
                ))
          ]));
    });
  }

  Future<List<PopupMenuEntry>> getLocalUsersItems(
      GlobalViewModel vm, BuildContext context) async {
    var itemList = <PopupMenuEntry>[];
    var userList = vm.loginUsers;
    userList.forEach((user) {
      GlobalKey _itemKey = GlobalKey();
      itemList.add(PopupMenuItem(
        key: _itemKey,
        child: ListTile(
          leading: CircleAvatar(
              backgroundImage: PictureRepository.getPictureFromId(user.iconId,
                  sinaImgSize: SinaImgSize.small)),
          title: Text(user.screenName),
          trailing: IconButton(
              padding: EdgeInsets.all(0),
              icon: Icon(
                Icons.remove_circle,
                color: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(context);
                vm.removeLocalUser(user.idstr);
              }),
          contentPadding: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
          onTap: () {
            Navigator.pop(context);

            if (user.idstr != vm.currentUser.idstr) {
              vm.switchCurrentUser(user.idstr);
            }
          },
          selected: user.idstr == vm.currentUser.idstr,
        ),
      ));
      itemList.add(PopupMenuDivider(
        height: 1,
      ));
    });

    itemList.add(PopupMenuItem(
      child: InkWell(
        child: Row(children: [
          Icon(Icons.add_circle, color: Colors.green),
        ], mainAxisAlignment: MainAxisAlignment.center),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        },
      ),
    ));

    return itemList;
  }

  Widget _buildExpandedItem(
      IconData iconData, Color color, String text, ThemeData theme,
      {double size}) {
    return SizedBox.expand(
        child: InkWell(
            onTap: () {},
            child: SizedBox.expand(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ClipRRect(
                    child: SizedBox(
                        width: 42,
                        height: 42,
                        child: Icon(
                          iconData,
                          color: color,
                          size: size ?? 30,
                        ))),
                Text(text, style: theme.textTheme.subtitle2)
              ],
            ))));
  }
}
