import 'package:mobx/mobx.dart';

part 'connectivity_store.g.dart';

class ConnectivityStore = ConnectivityStoreBase
    with _$ConnectivityStore;

abstract class ConnectivityStoreBase with Store {
  @observable
  bool connected = true;

  @action
  void setConnected(bool isConnected){
    connected = isConnected;
  }

}