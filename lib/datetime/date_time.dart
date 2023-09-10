// return todays date as yyyymmdd
String getTodaysDateTime(){
  DateTime datetime = DateTime.now();

  String yyyy = datetime.year.toString();
  String mm = datetime.month.toString();
  String dd = datetime.day.toString();

  if(mm.length == 1){
    mm = '0$mm';
  }

  if(dd.length == 1){
    mm = '0$dd';
  }

  String yyyymmdd = yyyy + mm + dd;
  return yyyymmdd;
}



// convert yyyymmdd to datetime obj
DateTime convertStringIntoDateTime(String yyyymmdd){
  int yyyy = int.parse(yyyymmdd.substring(0,4));
  int mm = int.parse(yyyymmdd.substring(4,6));
  int dd = int.parse(yyyymmdd.substring(6,8));

  return DateTime(yyyy,mm,dd);
}


// convert datetime obj into string
String convertDateTimeIntoString(DateTime datetime){
  String yyyy = datetime.year.toString();
  String mm = datetime.month.toString();
  String dd = datetime.day.toString();

  if(mm.length == 1){
    mm = '0$mm';
  }

  if(dd.length == 1){
    mm = '0$dd';
  }

  String yyyymmdd = yyyy + mm + dd;
  return yyyymmdd;
}