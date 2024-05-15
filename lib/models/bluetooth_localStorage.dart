import 'package:localstorage/localstorage.dart';
import 'package:smart_scarecrow/services/stream/motion.dart';
import 'package:smart_scarecrow/services/stream/sound.dart';
import 'package:smart_scarecrow/services/stream/weekly_report.dart';

class StorageModels{
  static TodoList list = new TodoList();
  static LocalStorage soundStorage = new LocalStorage('sound-storage');
  static LocalStorage motionStorage = new LocalStorage('motion-storage');
  static LocalStorage weeklyStorage = new LocalStorage('weekly-storage');
  static LocalStorage analyticStorage = new LocalStorage('analytics-storage');

  // static bool initialized = false;
}

// SOUND AND MOTION
class TodoDate {
  String date;
  TodoDate({required this.date});

  toJSONEncodable() {
    Map<String, dynamic> m = new Map();
    m['date'] = date;

    return m;
  }
}

class TodoTime {
  String time;
  TodoTime({required this.time});

  toJSONEncodable() {
    Map<String, dynamic> m = new Map();
    m['time'] = time;

    return m;
  }
}

// // WEEKLY REPORT
// class TodoAnalytics {
//   String healthy,moderate,not_healthy;
//   TodoAnalytics({required this.healthy, required this.moderate, required this.not_healthy});
//
//   AnylyticstoJSONEncodable() {
//     Map<String, dynamic> m = new Map();
//     m['healthy'] = healthy;
//     m['moderate'] = moderate;
//     m['not_healthy'] = not_healthy;
//
//     return m;
//   }
// }

class TodoList {

  // SOUND
  SoundDatetoJSONEncodable() {
    return soundStreamServices.value!.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }
  SoundTimetoJSONEncodable() {
    return soundStreamServices.valueTime!.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }

  // MOTION
  MotionDatetoJSONEncodable() {
    return motionStreamServices.value!.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }
  MotionTimetoJSONEncodable() {
    return motionStreamServices.valueTime!.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }

  // // WEEKLY REPORT
  // WeeklytoJSONEncodable() {
  //   return weeklyReportStreamServices.value!.map((item) {
  //     return item.toJSONEncodable();
  //   }).toList();
  // }
}