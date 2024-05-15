import 'package:rxdart/rxdart.dart';

class ShowNotificationStreamServices{
  // SHOW NOTIFICATION
  BehaviorSubject<bool> subject = new BehaviorSubject();
  Stream get stream => subject.stream;
  bool? get value => subject.value;

  updateRecord({required bool data}){
    subject.add(data);
  }
  //
  // // IS SOUND
  // BehaviorSubject<bool> isSound = new BehaviorSubject();
  // Stream get streamisSound => subject.stream;
  // bool? get valueisSound => subject.value;
  //
  // updateisSound({required bool data}){
  //   subject.add(data);
  // }
}
final ShowNotificationStreamServices showNotificationStreamServices = new ShowNotificationStreamServices();