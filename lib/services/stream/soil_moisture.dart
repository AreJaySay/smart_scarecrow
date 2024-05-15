import 'package:rxdart/rxdart.dart';

class SoilStreamServices{
  // DATE
  BehaviorSubject<double> subject = new BehaviorSubject();
  Stream get stream => subject.stream;
  double? get value => subject.value;

  updateRecord({required double data}){
    subject.add(data);
  }
}

SoilStreamServices soilStreamServices = new SoilStreamServices();