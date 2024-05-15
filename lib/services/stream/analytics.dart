import 'package:rxdart/rxdart.dart';
import 'package:smart_scarecrow/models/bluetooth_localStorage.dart';

class AnalyticStreamServices{
  // ANALYTICS
  static List week1 = ["0","0","0"];
  static List week2 = ["0","0","0"];
  static List week3 = ["0","0","0"];
  static List week4 = ["0","0","0"];
  static List week5 = ["0","0","0"];
  // static List june = ["0","0","0"];
  // static List july = ["0","0","0"];
  // static List aug = ["0","0","0"];
  // static List sept = ["0","0","0"];
  // static List oct = ["0","0","0"];
  // static List nov = ["0","0","0"];
  // static List dec = ["0","0","0"];

  BehaviorSubject<String> subject = new BehaviorSubject();
  Stream get stream => subject.stream;
  String? get value => subject.value;

  updateRecord({required String data}){
    subject.add(data);
  }
}
final AnalyticStreamServices analyticStreamServices = new AnalyticStreamServices();