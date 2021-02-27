import 'package:mobx/mobx.dart';

part 'messageStore.g.dart';

class Gunnar = _Gunnar with _$Gunnar;

abstract class _Gunnar with Store {
  @observable
  String msg = '';

  @action
  void setMessage(String message){
    msg = message + '!!!';
  }

  @computed
  String get importantMsg => this.msg + 'hej';

}