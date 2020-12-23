import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:minimal_bus_hk/interface/localized_data.dart';

class CustomMapPinInfo  extends LocalizedData{
  final String identifier;
  final LatLng positionForMap;
  Map<String, Map<String, String>> _localizedData = Map();
  static final String localizationKeyForDescription = "description";

  CustomMapPinInfo(String identifier, LatLng position, String enDescription, String tcDescription, String scDescription):this.identifier = identifier, this.positionForMap = position{
    Map<String, String> descriptionData = Map();
    descriptionData["en"] = enDescription;
    descriptionData["tc"] = tcDescription;
    descriptionData["sc"] = scDescription;
    _localizedData[localizationKeyForDescription] = descriptionData;


  }

  @override
  Map<String, Map<String, String>> getLocalizedData() {
    return _localizedData;

  }
}