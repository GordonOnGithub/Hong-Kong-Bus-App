import 'package:minimal_bus_hk/model/bus_stop.dart';
import 'package:minimal_bus_hk/model/bus_stop_detail.dart';
import 'package:minimal_bus_hk/model/directional_route.dart';
import 'package:minimal_bus_hk/utils/stores.dart';

class JourneyPlannerUtils{

  static List<BusStopDetail> findPath(String fromStopId , String  toStopId, int transit){
    if(!Stores.dataManager.stopRoutesMap.containsKey(fromStopId)){
      return [];
    }

      List<BusStopDetail> result = [];
      for(DirectionalRoute dr in Stores.dataManager.stopRoutesMap[fromStopId]){
          var map = dr.isInbound? Stores.dataManager.inboundBusStopsMap : Stores.dataManager.outboundBusStopsMap;
          if(!map.containsKey(dr.route.routeUniqueIdentifier)){
            continue;
          }
          var busStopsList = map[dr.route.routeUniqueIdentifier];
          bool startSearch = false;
          for(BusStop b in busStopsList){
            if(!startSearch && b.identifier == fromStopId){
              startSearch = true;
              continue;
            }else if (b.identifier == toStopId){
              result.add(Stores.dataManager.busStopDetailMap[fromStopId]);
              result.add(Stores.dataManager.busStopDetailMap[toStopId]);
              return result;
            }else if(transit > 0){
              var subResult = findPath(b.identifier, toStopId, transit - 1);
              if(subResult.length < 1){
                continue;
              }else{
                result.add(Stores.dataManager.busStopDetailMap[fromStopId]);
                result.add(Stores.dataManager.busStopDetailMap[b.identifier]);
                result.addAll(subResult);
                return result;
              }
            }else{
              continue;
            }
          }
          return [];

      }


  }
}