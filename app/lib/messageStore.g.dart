// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messageStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Gunnar on _Gunnar, Store {
  Computed<String> _$importantMsgComputed;

  @override
  String get importantMsg =>
      (_$importantMsgComputed ??= Computed<String>(() => super.importantMsg,
              name: '_Gunnar.importantMsg'))
          .value;

  final _$msgAtom = Atom(name: '_Gunnar.msg');

  @override
  String get msg {
    _$msgAtom.reportRead();
    return super.msg;
  }

  @override
  set msg(String value) {
    _$msgAtom.reportWrite(value, super.msg, () {
      super.msg = value;
    });
  }

  final _$_GunnarActionController = ActionController(name: '_Gunnar');

  @override
  void setMessage(String message) {
    final _$actionInfo =
        _$_GunnarActionController.startAction(name: '_Gunnar.setMessage');
    try {
      return super.setMessage(message);
    } finally {
      _$_GunnarActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
msg: ${msg},
importantMsg: ${importantMsg}
    ''';
  }
}
