import 'package:mobx/mobx.dart';

import 'dart:developer';

import 'package:learning_flutter/services/parseServerInteractions.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

part 'user.g.dart';

class User = _User with _$User;

abstract class _User with Store {
   _User({this.parent});
  var parent;


// TODO: Why observable??? Perhaps even make private?
  @observable
  Map<String, String> userCredentials;

  // @observable
  // ParseUser currentUser;

  String _id = null;

  String get id {
    return _id;
  }

  Future<ParseUser> get currentUser async{
    return await ParseUser.currentUser();
  }

  @action
  initUser() async {
    print('init user triggered');
    var userCredentials = await createUserCredentailsFromHardware();
    this.userCredentials = userCredentials;
    try {
      await initParse(this.userCredentials['userId'], this.userCredentials['userPassword']);
      ParseUser usr = await ParseUser.currentUser();
      this._id = usr.objectId;
      // this.currentUser = await ParseUser.currentUser();
    } catch(err) {
      log('error', error: err);
    }
  }
  
  // @observable
  // String userName = '';
  
}