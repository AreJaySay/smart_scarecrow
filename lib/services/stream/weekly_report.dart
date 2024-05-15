import 'package:rxdart/rxdart.dart';
import 'package:smart_scarecrow/models/bluetooth_localStorage.dart';

class WeeklyReportStreamServices{
  String sun,mon,tue,wed,thu,fri,sat;

  WeeklyReportStreamServices({
    this.sun = "0",
    this.mon = "0",
    this.tue = "0",
    this.wed = "0",
    this.thu = "0",
    this.fri = "0",
    this.sat = "0",
  });

  BehaviorSubject<String> subject = new BehaviorSubject();
  Stream get stream => subject.stream;
  String? get value => subject.value;

  updateRecord({required String data}){
    subject.add(data);
  }
}

final WeeklyReportStreamServices weeklyReportStreamServices = new WeeklyReportStreamServices();