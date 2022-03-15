import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import 'globals.dart' as globals;
import 'home.dart';

void main() async {
  await AwesomeNotifications().initialize(
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


  void sendNotification(int hour, int minute, String question, String ans1, String ans2, String ans3) async {

    if(!globals.notificationsAllowed){
      await globals.requestUserPermission();
    }

    if(!globals.notificationsAllowed){
      return;
    }
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 100,
          channelKey: "awesome_notifications",
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
        schedule: NotificationCalendar.fromDate(date: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, hour, minute))
    );
  }




  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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

