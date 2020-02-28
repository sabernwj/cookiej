import 'package:cookiej/cookiej/config/config.dart';


class AccessState{
  ///有currentAccess的话loginAccesses长度必不为0
  Access currentAccess;
  Map<String,Access> loginAccesses;
  AccessState.init(){
    this.loginAccesses=new Map<String,Access>();
  }
  AccessState.fromJson(Map<String, dynamic> json){
    currentAccess=Access.fromJson(json[Config.currentAccessStorageKey]);
    if(json[Config.loginAccessesStorageKey]!=null){
      loginAccesses=new Map<String,Access>();
      json[Config.loginAccessesStorageKey].forEach((k,v){
        loginAccesses[k]=Access.fromJson(v);
      });
    }
  }
  Map<String, dynamic> toJson() {
    if(currentAccess==null){
      return null;
    }
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[Config.currentAccessStorageKey]=this.currentAccess.toJson();
    loginAccesses.forEach((k,v){
      data[Config.loginAccessesStorageKey][k]=v;
    });
    return data;
  }
}
class Access{
  String uid;
  String accessToken;

  Access.fromJson(Map<String, dynamic> json){
    uid=json['uid'];
    accessToken=json['access_token'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid']=this.uid;
    data['access_token']=this.accessToken;
    return data;
  }
}

///设置程序运行的AccessState
class SetAccessState{
  final Access access;
  SetAccessState(this.access);
}
///获取当前用户
class GetCurrentAccess{}

///更换当前用户
class UpdateCurrentAccess{
  final Access access;
  UpdateCurrentAccess(this.access);
}

///添加新用户
class AddNewAccess{
  final Access access;
  AddNewAccess(this.access);
}

///移除一个已经登陆的用户
class RemoveAccess{
  final Access access;
  RemoveAccess(this.access);
}