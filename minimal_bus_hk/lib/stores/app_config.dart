import 'package:mobx/mobx.dart';

part 'app_config.g.dart';

class AppConfigStore = AppConfigStoreBase with _$AppConfigStore;

abstract class AppConfigStoreBase with Store {
  @observable
  int arrivalImminentTimeMilliseconds = 60000;

  @action
  void setArrivalImminentTimeMilliseconds(int timeMilliseconds){
    arrivalImminentTimeMilliseconds = timeMilliseconds;
  }

  @observable
  int arrivalExpiryTimeMilliseconds = -30000;//should be < 0

  @action
  void setArrivalExpiryTimeMilliseconds(int timeMilliseconds){
    arrivalExpiryTimeMilliseconds = timeMilliseconds;
  }

  final int etaExpiryTimeMilliseconds = 30000;
}