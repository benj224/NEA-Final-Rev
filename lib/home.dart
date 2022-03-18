import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
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

            AlertDialog(//dialog to request user permission for notifications
              title: Text("Notification Access Required"),
              content: Text("This App required access to notificatins to function"),
              actions: <Widget>[
                TextButton(
                    onPressed: () async {
                      Navigator.pop(context, "Ok");
                      await AwesomeNotifications().requestPermissionToSendNotifications();
                      globals.notificationsAllowed = await AwesomeNotifications().isNotificationAllowed();
                    },
                    child: Text("OK")
                ),
                TextButton(
                    onPressed: () => Navigator.pop(context, "Cancel"),
                    child: Text("Cancel")
                )
              ],
            )
    );
  }


  var _result;

  @override
  void initState() {
    //check permissions for notification access

    globals.requestUserPermission = requestUserPermission;

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