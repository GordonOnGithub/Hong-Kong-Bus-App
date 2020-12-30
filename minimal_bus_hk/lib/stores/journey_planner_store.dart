import 'package:minimal_bus_hk/model/bus_stop.dart';
import 'package:minimal_bus_hk/model/bus_stop_detail.dart';
import 'package:minimal_bus_hk/utils/stores.dart';
import 'package:mobx/mobx.dart';

part 'journey_planner_store.g.dart';

class JourneyPlannerStore = JourneyPlannerStoreBase
    with _$JourneyPlannerStore;

enum StopSelectionMode{
  none,
  origin,
  destination
}

abstract class JourneyPlannerStoreBase with Store {

  @observable
  StopSelectionMode selectionMode = StopSelectionMode.none;

  @action
  void setSelectionMode(StopSelectionMode mode){
    selectionMode = mode;
    filterKeywords = "";
  }

  @observable
  String filterKeywords;

  @action
  void setFilterKeywords(String keywords){
    filterKeywords = keywords;
  }

  @observable
  String originStopId;

  @action
  void setOriginStopId(String id){
    originStopId = id;
  }

  @computed
  BusStopDetail get originBusStop{
    if(originStopId != null && Stores.dataManager.busStopDetailMap.containsKey(originStopId)){
      return Stores.dataManager.busStopDetailMap[originStopId];
    }else{
      return null;
    }
  }

  @observable
  String destinationStopId;

  @action
  void setDestinationStopId(String id){
    destinationStopId = id;
  }

  @computed
  BusStopDetail get destinationBusStop{
    if(destinationStopId != null && Stores.dataManager.busStopDetailMap.containsKey(destinationStopId)){
      return Stores.dataManager.busStopDetailMap[destinationStopId];
    }else{
      return null;
    }
  }

  @computed
  List<String> get _keywords{
    return filterKeywords.split(" ");
  }
  @computed
  List<BusStopDetail> get filteredBusStopDetailList{
    List<BusStopDetail> busStops = Stores.dataManager.busStopDetailMap != null? Stores.dataManager.busStopDetailMap.values.toList() : [];
    if(filterKeywords != null && filterKeywords.length > 0 && busStops.length > 0 && (originStopId != null || destinationBusStop != null)){
      var filteredList =  <BusStopDetail>[];
      filteredList.addAll(busStops.where((element) {
        if(element == null) return false;
        if(originStopId == element.identifier || destinationStopId == element.identifier){
          return false;
        }

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