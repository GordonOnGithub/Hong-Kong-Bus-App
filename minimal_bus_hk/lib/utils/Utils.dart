class Utils{
  static String dateTimeToETAString(DateTime dateTime){
    if(dateTime == null){
      return "-";
    }
    var localTime = dateTime.add(Duration(hours: 8));

    return "${localTime.hour}:${localTime.minute}";

  }

}