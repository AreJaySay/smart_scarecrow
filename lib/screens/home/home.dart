import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smart_scarecrow/models/bluetooth_localStorage.dart';
import 'package:smart_scarecrow/screens/home/bluetooth/main_screen.dart';
import 'package:smart_scarecrow/screens/landing.dart';
import 'package:smart_scarecrow/services/routes.dart';
import 'package:smart_scarecrow/services/stream/analytics.dart';
import 'package:smart_scarecrow/utils/palettes/colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Routes _routes = new Routes();

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = <ChartData>[
      ChartData('Week 1', double.parse(AnalyticStreamServices.week1[0]), double.parse(AnalyticStreamServices.week1[1]), double.parse(AnalyticStreamServices.week1[2])),
      ChartData('Week 2', double.parse(AnalyticStreamServices.week2[0]), double.parse(AnalyticStreamServices.week2[1]), double.parse(AnalyticStreamServices.week2[2])),
      ChartData('Week 3', double.parse(AnalyticStreamServices.week3[0]), double.parse(AnalyticStreamServices.week3[1]), double.parse(AnalyticStreamServices.week3[2])),
      ChartData('Week 4', double.parse(AnalyticStreamServices.week4[0]), double.parse(AnalyticStreamServices.week4[1]), double.parse(AnalyticStreamServices.week4[2])),
      ChartData('Week 5', double.parse(AnalyticStreamServices.week5[0]), double.parse(AnalyticStreamServices.week5[1]), double.parse(AnalyticStreamServices.week5[2])),
    ];
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Analytics",style: TextStyle(fontFamily: "semibold",fontSize: 18,color: Colors.white),),
          centerTitle: true,
          backgroundColor: AppColors.green,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: Icon(Icons.bluetooth_connected,color: Colors.white),
              onPressed: (){
                Future.delayed(const Duration(milliseconds: 0), (){
                  _routes.navigator_push(context, BluetoothMainScreen());
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.refresh,color: Colors.white),
              onPressed: (){
                Future.delayed(const Duration(milliseconds: 0), (){
                  _routes.navigator_pushreplacement(context, Landing(), transitionType: PageTransitionType.fade);
                });
              },
            )
          ],
        ),
        body: FutureBuilder(
          future: StorageModels.analyticStorage.ready,
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            // if (!StorageModels.initialized) {
            var week1 = StorageModels.weeklyStorage.getItem('week1');
            var week2 = StorageModels.weeklyStorage.getItem('week2');
            var week3 = StorageModels.weeklyStorage.getItem('week3');
            var week4 = StorageModels.weeklyStorage.getItem('week4');
            var week5 = StorageModels.weeklyStorage.getItem('week5');

            if (week1 != null) {
              AnalyticStreamServices.week1 = week1 == null ? ["0","0","0"] : week1;
            }if (week2 != null) {
              AnalyticStreamServices.week2 = week2 == null ? ["0","0","0"] : week2;
            }if (week3 != null) {
              AnalyticStreamServices.week3 = week3 == null ? ["0","0","0"] : week3;
            }if (week4 != null) {
              AnalyticStreamServices.week4 = week4 == null ? ["0","0","0"] : week4;
            }if (week5 != null) {
              AnalyticStreamServices.week5 = week5 == null ? ["0","0","0"] : week5;
            }


            return Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  height: 50,
                  child: Row(
                    children: [
                      Icon(Icons.circle,size: 15,color: AppColors.green,),
                      SizedBox(
                        width: 5,
                      ),
                      Text("Healthy"),
                      Spacer(),
                      Icon(Icons.circle,size: 15,color: AppColors.yellow,),
                      SizedBox(
                        width: 5,
                      ),
                      Text("Moderate"),
                      Spacer(),
                      Icon(Icons.circle,size: 15,color: AppColors.red,),
                      SizedBox(
                        width: 5,
                      ),
                      Text("Not healthy"),
                    ],
                  ),
                ),
                Expanded(
                    child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(
                          labelPlacement: LabelPlacement.onTicks,
                          labelRotation: -90,
                        ),
                        series: <CartesianSeries>[
                          ColumnSeries<ChartData, String>(
                              color: AppColors.green,
                              dataSource: chartData,
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y
                          ),
                          ColumnSeries<ChartData, String>(
                              color: AppColors.yellow,
                              dataSource: chartData,
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y1
                          ),
                          ColumnSeries<ChartData, String>(
                              color: AppColors.red,
                              dataSource: chartData,
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y2
                          )
                        ]
                    )
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            );
          },
        )
    );
  }
}
class ChartData {
  ChartData(this.x, this.y, this.y1, this.y2);
  final String x;
  final double? y;
  final double? y1;
  final double? y2;
}