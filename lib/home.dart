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
                  dev.log(globals.notificationsAllowed.toString());
                  globals.notificationsAllowed = !globals.notificationsAllowed;
                  dev.log(globals.notificationsAllowed.toString());
                });
              },
            )
    );
  }



  @override
  void initState() {
    //check permissions for notification access
    if(!globals.notificationsAllowed){
      Future.delayed(Duration.zero, (){
        requestUserPermission();
      });


    }

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