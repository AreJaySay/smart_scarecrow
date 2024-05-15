import 'package:rxdart/rxdart.dart';
import 'package:smart_scarecrow/models/bluetooth_localStorage.dart';

class SoundStreamServices{

  // DATE
  BehaviorSubject<List<TodoDate>> subject = new BehaviorSubject.seeded([]);
  Stream get stream => subject.stream;
  List<TodoDate>? get value => subject.value;

  updateRecord({required List<TodoDate> data}){
    subject.add(data);
  }
  addRecord({required TodoDate data}){
    value!.add(data);
  }

  // TIME
  BehaviorSubject<List<TodoTime>> Timesubject = new BehaviorSubject.seeded([]);
  Stream get streamTime => Timesubject.stream;
  List<TodoTime>? get valueTime => Timesubject.value;

  updateTimeRecord({required List<TodoTime> data}){
    Timesubject.add(data);
  }
  addTimeRecord({required TodoTime data}){
    valueTime!.add(data);
  }
}

final SoundStreamServices soundStreamServices = new SoundStreamServices();