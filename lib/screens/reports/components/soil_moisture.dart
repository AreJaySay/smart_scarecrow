import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pretty_gauge/pretty_gauge.dart';
import 'package:smart_scarecrow/models/bluetooth_localStorage.dart';
import 'package:smart_scarecrow/services/stream/show_notification.dart';
import 'package:smart_scarecrow/services/stream/soil_moisture.dart';
import 'package:smart_scarecrow/services/stream/weekly_report.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SoilMoisture extends StatefulWidget {
  @override
  State<SoilMoisture> createState() => _SoilMoistureState();
}

class _SoilMoistureState extends State<SoilMoisture> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    soilStreamServices.updateRecord(data: 200);
    weeklyReportStreamServices.updateRecord(data: "0");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 15),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Center(
              child: StreamBuilder<double>(
                stream: soilStreamServices.subject,
                builder: (context, snapshot) {
                  return !snapshot.hasData ?
                  SizedBox(
                    width: double.infinity,
                    height: 260,
                    child: Center(child: CircularProgressIndicator()),
                  ) :
                  PrettyGauge(
                    gaugeSize: 260,
                    segments: [
                      GaugeSegment('Low', 300, Colors.red),
                      GaugeSegment('Medium', 350, Colors.orange),
                      GaugeSegment('High', 350, Colors.green),
                    ],
                    showMarkers: false,
                    currentValue: snapshot.data,
                    maxValue: 1000,
                    minValue: 0,
                    displayWidget: Text('Soil is', style: TextStyle(fontFamily: "regular")),
                    valueWidget: Text(snapshot.data! < 300 ? "Not healthy" : snapshot.data! > 300 && snapshot.data! < 650 ? "Moderate" : "Healthy",style: TextStyle(fontFamily: "bold",fontSize: 15),),
                  );
                }
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text("Daily Reports",style: TextStyle(fontFamily: "regular",fontSize: 15),),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: weeklyReportStreamServices.subject,
                      builder: (context, weeklySnapshot) {
                        return !weeklySnapshot.hasData ?
                        Center(
                          child: CircularProgressIndicator(),
                        ) :
                        FutureBuilder(
                          future: StorageModels.weeklyStorage.ready,
                          builder: (BuildContext context, AsyncSnapshot snapshot){
                            if (snapshot.data == null) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            // if (!StorageModels.initialized) {
                            var sun = StorageModels.weeklyStorage.getItem('sun');
                            var mon = StorageModels.weeklyStorage.getItem('mon');
                            var tue = StorageModels.weeklyStorage.getItem('tue');
                            var wed = StorageModels.weeklyStorage.getItem('wed');
                            var thu = StorageModels.weeklyStorage.getItem('thu');
                            var fri = StorageModels.weeklyStorage.getItem('fri');
                            var sat = StorageModels.weeklyStorage.getItem('sat');

                            if (sun != null) {
                              weeklyReportStreamServices.sun = sun == null ? "0" : sun;
                              weeklyReportStreamServices.mon = mon == null ? "0" : mon;
                              weeklyReportStreamServices.tue = tue == null ? "0" : tue;
                              weeklyReportStreamServices.wed = wed == null ? "0" : wed;
                              weeklyReportStreamServices.thu = thu == null ? "0" : thu;
                              weeklyReportStreamServices.fri = fri == null ? "0" : fri;
                              weeklyReportStreamServices.sat = sat == null ? "0" : sat;
                            }
                            return SfCartesianChart(
                              // Initialize category axis
                                primaryXAxis: CategoryAxis(),
                                series: <LineSeries<SalesData, String>>[
                                  LineSeries<SalesData, String>(
                                    // Bind data source
                                      dataSource:  <SalesData>[
                                        SalesData('Sun', double.parse(DateFormat('EEEE').format(DateTime.now()) == "Sunday" ? weeklySnapshot.data! : weeklyReportStreamServices.sun)),
                                        SalesData('Mon', double.parse(DateFormat('EEEE').format(DateTime.now()) == "Monday" ? weeklySnapshot.data! : weeklyReportStreamServices.mon)),
                                        SalesData('Tue', double.parse(DateFormat('EEEE').format(DateTime.now()) == "Tuesday" ? weeklySnapshot.data! : weeklyReportStreamServices.tue)),
                                        SalesData('Wed', double.parse(DateFormat('EEEE').format(DateTime.now()) == "Wednesday" ? weeklySnapshot.data! : weeklyReportStreamServices.wed)),
                                        SalesData('Thu', double.parse(DateFormat('EEEE').format(DateTime.now()) == "Thursday" ? weeklySnapshot.data! : weeklyReportStreamServices.thu)),
                                        SalesData('Fri', double.parse(DateFormat('EEEE').format(DateTime.now()) == "Friday" ? weeklySnapshot.data! : weeklyReportStreamServices.fri)),
                                        SalesData('Sat', double.parse(DateFormat('EEEE').format(DateTime.now()) == "Saturday" ? weeklySnapshot.data! : weeklyReportStreamServices.sat))
                                      ],
                                      xValueMapper: (SalesData sales, _) => sales.year,
                                      yValueMapper: (SalesData sales, _) => sales.sales,
                                      markerSettings: MarkerSettings(
                                        isVisible: true,
                                      ),
                                      pointColorMapper: (SalesData, int) => SalesData.sales <= 35 ? Colors.red : SalesData.sales > 35 && SalesData.sales <= 60 ? Colors.orangeAccent : Colors.green
                                  )
                                ]
                            );
                          },
                        );
                      }
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
