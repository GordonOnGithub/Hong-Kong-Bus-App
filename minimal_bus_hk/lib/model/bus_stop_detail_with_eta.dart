import 'package:minimal_bus_hk/model/bus_stop_detail.dart';
import 'package:minimal_bus_hk/model/eta.dart';

class BusStopDetailWithETA{
  final BusStopDetail busStopDetail;
  final int sequence;
  final ETA eta;

  BusStopDetailWithETA(this.busStopDetail, this.eta, this.sequence);

}