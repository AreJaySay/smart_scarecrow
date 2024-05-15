import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class NotificationMessage{
  Future<void> notificSnackbar(context,{required String message,})async{
    await Flushbar(
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      titleText: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        ],
      ),
      isDismissible: true,
      messageText: Text(message,style: TextStyle(color: Colors.white,fontFamily: "regular"),),
      duration: Duration(seconds: 20),
      backgroundColor: Colors.blueGrey.withOpacity(0.9),
      margin: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
      borderRadius: BorderRadius.circular(5),
      icon: Center(
        // child: Container(
        //   width: 40,
        //   height: 40,
        //   decoration: BoxDecoration(
        //       color: Colors.grey[200],
        //       border: Border.all(color: AppColors.appmaincolor,width: 2),
        //       borderRadius: BorderRadius.circular(1000),
        //       image: subscriptionDetails.currentdata[0]["coach"]["logo"] == null ?
        //       DecorationImage(
        //           fit: BoxFit.cover,
        //           image: AssetImage("assets/icons/no_profile.png")
        //       ) :
        //       DecorationImage(
        //           fit: BoxFit.cover,
        //           image: NetworkImage(subscriptionDetails.currentdata[0]["coach"]["logo"])
        //       )
        //   ),
        // ),
      ),
      maxWidth: double.infinity,
    )..show(context);
  }
}