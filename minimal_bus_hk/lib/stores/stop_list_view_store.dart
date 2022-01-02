import 'package:minimal_bus_hk/model/bus_stop_detail.dart';
import 'package:minimal_bus_hk/utils/stores.dart';
import 'package:mobx/mobx.dart';

part 'stop_list_view_store.g.dart';

class StopListViewStore = StopListViewStoreBase with _$StopListViewStore;

abstract class StopListViewStoreBase with Store {

  @observable
  String filterKeywords = "";

  @action
  void setFilterKeywords(String keywords){
    filterKeywords = keywords;
  }

  @computed
  List<String> get _keywords{
    return filterKeywords.split(" ");
  }
  @computed
  List<BusStopDetail> get filteredBusStopDetailList{
    List<BusStopDetail> busStops = Stores.dataManager.busStopDetailMap != null? Stores.dataManager.busStopDetailMap!.values.toList() : [];
    if(filterKeywords != null && filterKeywords.length > 0 && busStops.length > 0){
      var filteredList =  <BusStopDetail>[];
      filteredList.addAll(busStops.where((element) {
        if(element == null) return false;


        for(var keyword in _keywords){
          if(( element.englishName.toLowerCase().contains(
              keyword.toLowerCase()))
              || element.TCName.toLowerCase().contains(
                  keyword.toLowerCase())
              || element.SCName.toLowerCase().contains(
                  keyword.toLowerCase())){

          }else{
            return false;
          }
        }
        return true;
      }));

      return filteredList;

    }else{
      return busStops;
    }
  }
}