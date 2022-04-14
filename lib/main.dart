import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:html';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:cron/cron.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:workmanager/workmanager.dart';
import 'package:localstorage/localstorage.dart';
//import 'package:build_runner/build_runner.dart';



import 'globals.dart' as globals;
import 'classes.dart';
import 'home.dart';



///TODO add box ot change frequesncy of pack
///TODO add sort by filter



void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    scheduleQuestions(); //simpleTask will be emitted here.
    return Future.value(true);
  });
}










void main() async {

  ///Initialize the awesome notifications service and create a channel for us to create notifications on

  /*bool done = await AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
            channelKey: 'awesome_notifications',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
      debug: true
  );*/


  ///look at shared prefrences
  





  /*Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode: true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  );
  Workmanager().registerOneOffTask(
      "1",
      "simpleTask",
      initialDelay: Duration(minutes: 1)
  ); */




  runApp(const MyApp());

}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  void initState(){
    ///check for notification permissions
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      notificationsAllowed();
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

