import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'dart:developer' as dev;
//import 'package:build_runner/build_runner.dart';



import 'globals.dart' as globals;
import 'classes.dart';
import 'home.dart';

///add button for settings fix packs





void main() async {

  await Hive.initFlutter();


  Hive.registerAdapter(HivePackAdapter());
  Hive.registerAdapter(HiveQuestionAdapter());
  Hive.registerAdapter(HiveAnswerAdapter());


  await Hive.openBox("Globals");
  /*dev.log("not set");
  Box<List<HivePack>> box = Hive.box("Globals");
  dev.log("set");
  List<HivePack>? _packs = box.get("packs");///erroring here need to go back to casting to hivepack, maby make a function.
  if(!(_packs == null)){
    globals.packs = _packs!;
  }*/
  globals.packs = await packsFromHive();

  AwesomeNotifications().removeChannel("awesome_notifications");
  dev.log("got to here");
  /*await AwesomeNotifications().initialize(
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

  dev.log("done");*/














  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  void initState(){
    void sendNotification(int hour, int minute, String question, String ans1, String ans2, String ans3) async {

      if(!globals.notificationsAllowed){
        return;
      }
      await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 100,
            channelKey: "basic_channel",
            title: question,
            body: "test",
            //notificationLayout: NotificationLayout.BigPicture,
            //largeIcon: "https://avidabloga.files.wordpress.com/2012/08/emmemc3b3riadeneilarmstrong3.jpg",
            //bigPicture: "https://www.dw.com/image/49519617_303.jpg",
            showWhen: true,
          ),
          actionButtons: [
            NotificationActionButton(
              key: "a1",
              label: ans1,
              enabled: true,
              buttonType: ActionButtonType.Default,
            ),
            NotificationActionButton(
              key: "a2",
              label: ans2,
              enabled: true,
              buttonType: ActionButtonType.Default,
            ),
            NotificationActionButton(
              key: "a3",
              label: ans3,
              enabled: true,
              buttonType: ActionButtonType.Default,
            )
          ],
          schedule: NotificationCalendar.fromDate(date: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, DateTime.now().minute + 1))
        //schedule: NotificationCalendar.fromDate(date: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, hour, minute))
      );
    }

    void cancelAllNotifications(){
      AwesomeNotifications().cancelAll();
    }



    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      globals.notificationsAllowed = isAllowed;
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });


    AwesomeNotifications().createdStream.listen((ReceivedNotification notification) {
      print("Notification created: "+(notification.title ?? notification.body ?? notification.id.toString()));
    });

    AwesomeNotifications().displayedStream.listen((ReceivedNotification notification) {
      print("Notification displayed: "+(notification.title ?? notification.body ?? notification.id.toString()));
    });

    AwesomeNotifications().dismissedStream.listen((ReceivedAction dismissedAction) {
      print("Notification dismissed: "+(dismissedAction.title ?? dismissedAction.body ?? dismissedAction.id.toString()));
    });

    AwesomeNotifications().actionStream.listen((ReceivedAction action){
      print("Action received!");


    });


    dev.log("here");
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

