import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'dart:developer' as dev;

import 'globals.dart' as globals;
import 'makequestion.dart';
import 'createpack.dart';
import 'classes.dart';

///changes to make
///load all packs from hive in main function
///only save all packs to hive on done pack button.
///simplify buttons to use delete self method

class MyHomePage extends StatefulWidget{
  @override
  _MyHomePageState createState() => _MyHomePageState();




}

class _MyHomePageState extends State<MyHomePage> {


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

  Future<void> requestUserPermission() async {
    showDialog(
        context: context,
        builder: (_) =>
            NetworkGiffyDialog(
              buttonOkText: Text('Allow', style: TextStyle(color: Colors.white)),
              buttonCancelText: Text('Later', style: TextStyle(color: Colors.white)),
              buttonCancelColor: Colors.grey,
              buttonOkColor: Colors.deepPurple,
              buttonRadius: 0.0,
              image: Image.asset("assets/images/animated-bell.gif", fit: BoxFit.cover),
              title: Text('Get Notified!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600)
              ),
              description: Text('Allow Awesome Notifications to send to you beautiful notifications!',
                textAlign: TextAlign.center,
              ),
              entryAnimation: EntryAnimation.DEFAULT,
              onCancelButtonPressed: () async {
                Navigator.of(context).pop();
                globals.notificationsAllowed = await AwesomeNotifications().isNotificationAllowed();
                setState(() {
                  globals.notificationsAllowed = globals.notificationsAllowed;
                });
              },
              onOkButtonPressed: () async {
                Navigator.of(context).pop();
                await AwesomeNotifications().requestPermissionToSendNotifications();
                globals.notificationsAllowed = await AwesomeNotifications().isNotificationAllowed();
                setState(() {
                  globals.notificationsAllowed = globals.notificationsAllowed;
                });
              },
            )
    );
  }


  @override
  void initState() {
    //check permissions for notification access

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

  }


  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
        ),

        body: Center(
          child: Container(
            height: 600,
            child: ListView(
              children: globals.packs,
            ),
          ),
        ),
        floatingActionButton: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CreatePack(pack: Pack(enabled: true, name: "name", hivePack: HivePack(title: "<NewPack>",  questions: [], enabled: true, frequency: 2),))));
                },
              ),
            ),
          ],
        )
    );
  }
}