import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smart_scarecrow/screens/reports/components/motion.dart';
import 'package:smart_scarecrow/screens/reports/components/soil_moisture.dart';
import 'package:smart_scarecrow/screens/reports/components/sound.dart';
import 'package:smart_scarecrow/screens/reports/printing/printing.dart';
import 'package:smart_scarecrow/services/routes.dart';
import 'package:smart_scarecrow/utils/palettes/colors.dart';

class Report extends StatefulWidget {
  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final Routes _routes = new Routes();
  final List<String> _tabs = <String>[
    "Soil moisture",
    "Sound",
    "Motion",
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: DefaultTabController(
          length: _tabs.length,
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverOverlapAbsorber(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverSafeArea(
                    top: false,
                    bottom: Platform.isIOS ? false : true,
                    sliver: SliverAppBar(
                      backgroundColor: AppColors.green,
                      foregroundColor: Colors.white,
                      centerTitle: true,
                      title: Text('Modules Log Reports',style: TextStyle(fontFamily: "regular",fontSize: 18,color: Colors.white),),
                      floating: true,
                      pinned: true,
                      snap: true,
                      forceElevated: innerBoxIsScrolled,
                      bottom: TabBar(
                        tabs: _tabs
                            .map((String name) => Tab(text: name))
                            .toList(),
                        labelStyle: TextStyle(fontFamily: "bold",color: Colors.white),
                        unselectedLabelStyle: TextStyle(fontFamily: "regular",color: Colors.white38),
                        indicatorColor: Colors.white,
                      ),
                      actions: [
                        IconButton(
                          icon: Icon(Icons.print,color: Colors.white,),
                          onPressed: (){
                            _routes.navigator_push(context, Printing());
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                SoilMoisture(),
                SoundReports(),
                MotionReports()
              ]
            ),
          ),
        ),
      ),
    );
  }
}