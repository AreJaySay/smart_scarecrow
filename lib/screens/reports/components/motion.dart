import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_scarecrow/models/bluetooth_localStorage.dart';
import 'package:smart_scarecrow/services/stream/motion.dart';
import '../../../utils/palettes/colors.dart';

class MotionReports extends StatefulWidget {
  @override
  State<MotionReports> createState() => _MotionReportsState();
}

class _MotionReportsState extends State<MotionReports> {
  int? _selected;

  Future _getData() async {
    await StorageModels.motionStorage.ready;
    return await StorageModels.motionStorage.getItem('data');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: motionStreamServices.subject,
        builder: (context, AsyncSnapshot dateSnapshot) {
          return !dateSnapshot.hasData ?
          Center(
            child: CircularProgressIndicator(),
          ) :
          FutureBuilder(
            future: StorageModels.motionStorage.ready,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              // if (StorageModels.initialized) {
                var dateitems = StorageModels.motionStorage.getItem('date');
                var timeitems = StorageModels.motionStorage.getItem('time');

                if (dateitems != null) {
                  motionStreamServices.updateRecord(data: List<TodoDate>.from(
                    (dateitems as List).map(
                          (item) => TodoDate(
                        date: item['date'],
                      ),
                    ),
                  ));
                }
                if (timeitems != null) {
                  motionStreamServices.updateTimeRecord(data: List<TodoTime>.from(
                    (timeitems as List).map(
                          (item) => TodoTime(
                        time: item['time'],
                      ),
                    ),
                  ));
                }
              //   StorageModels.initialized = true;
              // }
              return dateSnapshot.data.isEmpty?
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    width: 150,
                    image: AssetImage("assets/icons/no_record.png"),
                  ),
                  Text("NO RECORD FOUND",style: TextStyle(fontFamily: "semibold",fontSize: 15,color: Colors.grey.shade600),),
                ],
              ) :
              StreamBuilder(
                  stream: motionStreamServices.Timesubject,
                  builder: (context, timeSnapshot) {
                    return ListView(
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                      children: [
                        for(int x = 0; x < dateSnapshot.data!.length; x++)...{
                          Card(
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(dateSnapshot.data![dateSnapshot.data!.length - x - 1].date.toString(),style: TextStyle(fontFamily: "regular"),),
                                  subtitle: Text(!timeSnapshot.hasData ? "Loading ..." : "${timeSnapshot.data!.length.toString()} Records"),
                                  leading: Icon(Icons.calendar_today),
                                  iconColor: AppColors.green,
                                  onTap: (){
                                    setState(() {
                                      _selected = _selected != null ? null : x;
                                    });
                                  },
                                ),
                                _selected != x ? Container() :
                                !timeSnapshot.hasData ?
                                Center(
                                  child: CircularProgressIndicator(),
                                ) :
                                Column(
                                  children: [
                                    for(int d = 0; d < timeSnapshot.data!.where((s) => DateFormat("dd MMM, yyyy").format(DateTime.parse(s.time)).toString() == dateSnapshot.data![dateSnapshot.data!.length - x - 1].date.toString()).toList().length; d++)...{
                                      Container(
                                        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                                        width: double.infinity,
                                        child: Row(
                                          children: [
                                            Icon(Icons.access_time_rounded,color: Colors.blueGrey,),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(DateFormat('hh:mm:ss a').format(DateTime.parse(timeSnapshot.data!.where((s) => DateFormat("dd MMM, yyyy").format(DateTime.parse(s.time)).toString() == dateSnapshot.data![dateSnapshot.data!.length - x - 1].date.toString()).toList()[d].time.toString())),style: TextStyle(fontFamily: "regular"),),
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                top: BorderSide(color: Colors.grey.shade100)
                                            )
                                        ),
                                      ),
                                    }
                                  ],
                                )
                              ],
                            ),
                          )
                        },
                        // TextButton(
                        //   child: Text("TEST"),
                        //   onPressed: ()async{
                        //     await StorageModels.motionStorage.clear();
                        //     motionStreamServices.updateRecord(data: StorageModels.motionStorage.getItem('time') ?? []);
                        //     motionStreamServices.updateTimeRecord(data: StorageModels.motionStorage.getItem('date') ?? []);
                        //   },
                        // ),
                      ],
                    );
                  }
              );
            },
          );
        }
    );
  }
}