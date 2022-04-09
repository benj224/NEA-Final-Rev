import 'dart:developer';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:cron/cron.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'dart:developer' as dev;
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
//import 'package:build_runner/build_runner.dart';



import 'globals.dart' as globals;
import 'classes.dart';
import 'home.dart';



///TODO add box ot change frequesncy of pack
///TODO add sort by filter






void main() async {

  ///Initialize the awesome notifications service and create a channel for us to create notifications on

  bool done = await AwesomeNotifications().initialize(
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
  );


  ///initialize the flutter service for hive (no path specified using default value)
  await Hive.initFlutter();


  ///register hive type adapters for storing items of the hive classes defined in classes.dart
  Hive.registerAdapter(HivePackAdapter());
  Hive.registerAdapter(HiveQuestionAdapter());
  Hive.registerAdapter(HiveAnswerAdapter());



  ///load the box into chache memory for fast access
  await Hive.openBox<List>("Globals");
  await Hive.openBox<bool>("Permissions");



  /*final cron = Cron();
  String time = (DateTime.now().minute + 2).toString() + " " + DateTime.now().hour.toString() + " " + DateTime.now().day.toString() + " " + DateTime.now().month.toString() + " *";
  //cron.schedule(Schedule.parse('0 0 * * *'), () async {
  cron.schedule(Schedule.parse(time), () async{
    log(time);

    scheduleQuestions();
  });*/

  final int alarmID = 0;
  await AndroidAlarmManager.initialize();

  /*runApp(const MyApp());
  await AndroidAlarmManager.periodic(
      const Duration(hours: 24),
      alarmID,
      scheduleQuestions,
      wakeup: false,
      startAt: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().add(Duration(hours: 24)).day, 0, 0 ));*/

  runApp(const MyApp());


  await AndroidAlarmManager.periodic(
  const Duration(minutes: 3),
  alarmID,
  scheduleQuestions,
  wakeup: false);
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

