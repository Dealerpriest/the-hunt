// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$User on _User, Store {
  final _$userCredentialsAtom = Atom(name: '_User.userCredentials');

  @override
  Map<String, String> get userCredentials {
    _$userCredentialsAtom.reportRead();
    return super.userCredentials;
  }

  @override
  set userCredentials(Map<String, String> value) {
    _$userCredentialsAtom.reportWrite(value, super.userCredentials, () {
      super.userCredentials = value;
    });
  }

  final _$currentUserAtom = Atom(name: '_User.currentUser');

  @override
  ParseUser get currentUser {
    _$currentUserAtom.reportRead();
    return super.currentUser;
  }

  @override
  set currentUser(ParseUser value) {
    _$currentUserAtom.reportWrite(value, super.currentUser, () {
      super.currentUser = value;
    });
  }

  final _$initUserAsyncAction = AsyncAction('_User.initUser');

  @override
  Future initUser() {
    return _$initUserAsyncAction.run(() => super.initUser());
  }

  @override
  String toString() {
    return '''
userCredentials: ${userCredentials},
currentUser: ${currentUser}
    ''';
  }
}
