import 'package:minimal_bus_hk/model/eta.dart';
import 'package:minimal_bus_hk/utils/stores.dart';
import 'package:mobx/mobx.dart';

part 'eta_list_store.g.dart';

class ETAListStore = ETAListStoreBase with _$ETAListStore;

abstract class ETAListStoreBase with Store {

  @observable
  bool isLoading = true;

  @action
  void setIsLoading(bool isLoading){
    this.isLoading = isLoading;
  }

  @observable
  int? selectedETAListIndex;

  @action
  void setSelectedETAListIndex(int? index){
    if(selectedETAListIndex != index) {
      selectedETAListIndex = index;
    }else{
      selectedETAListIndex = null;
    }
  }

  @observable
  DateTime timeStampForChecking = DateTime.now();

  @action
  void updateTimeStampForChecking(){
    timeStampForChecking = DateTime.now();
  }

  @computed
  ObservableList<List<ETA>> get routesETAList{
    var result = ObservableList<List<ETA>>();
    if(Stores.dataManager.bookmarkedRouteStops == null ){
      return result;
    }

    for(var routeStop in Stores.dataManager.bookmarkedRouteStops!){
      if(Stores.dataManager.ETAMap != null && Stores.dataManager.ETAMap!.containsKey(routeStop)){
        var ETAs = Stores.dataManager.ETAMap![routeStop];
        var filteredETAs = <ETA>[];
        if(ETAs != null) {
          for (var eta in ETAs) {
            if (routeStop.matchETA(eta)) {
              filteredETAs.add(eta);
            }
          }
        }
        if(filteredETAs.length == 0){
          filteredETAs.add(ETA.notFound(routeStop.routeCode, routeStop.stopId,  routeStop.companyCode, routeStop.isInbound));
        }
        filteredETAs.sort((a,b){
          if(a.etaTimestamp == null || b.etaTimestamp == null){
            return 0;
          }
          return a.etaTimestamp!.compareTo(b.etaTimestamp!);});
        result.add(filteredETAs);
      }else{
        result.add([ETA.unknown(routeStop.routeCode, routeStop.stopId, routeStop.companyCode, routeStop.isInbound)]);
      }
    }

    return result;
  }

  @computed
  ObservableList<ETA> get displayedETAs{
    ObservableList<ETA> result = ObservableList();
    for(List<ETA> list in routesETAList ){
      for(ETA eta in list){
        if(( eta.etaTimestamp != null ) || eta == list.last){
          result.add(eta);
          break;
        }
      }
    }
    return result;
  }

}