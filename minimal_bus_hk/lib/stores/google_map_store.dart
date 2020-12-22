import 'package:minimal_bus_hk/model/bus_stop_detail.dart';
import 'package:mobx/mobx.dart';

part 'google_map_store.g.dart';

class GoogleMapStore = GoogleMapStoreBase
    with _$GoogleMapStore;

abstract class GoogleMapStoreBase with Store {
  @observable
  BusStopDetail selectedBusStop;

  @action
  void setSelectedBusStop(BusStopDetail busStop){
    selectedBusStop = busStop;
  }

}