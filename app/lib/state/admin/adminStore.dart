import 'package:learning_flutter/state/admin/checkpoints.dart';
import 'package:mobx/mobx.dart';


part 'adminStore.g.dart';

class AdminStore extends _AdminStore with _$AdminStore { 
  static AdminStore _instance; 
  static AdminStore getInstance() { 
    if (_instance == null) { 
      _instance = new AdminStore(); 
    }
    
    return _instance;
  }
}

abstract class _AdminStore with Store {

  Checkpoints checkpoints;


  _AdminStore(){
    checkpoints = Checkpoints(parent: this);
    checkpoints.init();
  }
}