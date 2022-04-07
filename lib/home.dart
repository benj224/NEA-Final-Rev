import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:nea/settings.dart';
import 'dart:developer' as dev;
import 'package:hive_flutter/hive_flutter.dart';

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



  ///send a dialoge box asking for permission to send notifications
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
              },
              onOkButtonPressed: () async {
                Navigator.of(context).pop();
                dev.log("exec 0");///probs not an issue on mobile
                await AwesomeNotifications().requestPermissionToSendNotifications();
                dev.log("exec 1");
                bool allowed = await AwesomeNotifications().isNotificationAllowed();
                dev.log("exec 2");
                setState(() {
                  if(allowed){
                    notificationsAllowed();
                  }
                });
              },
            )
    );
  }







  @override
  void initState() {


    ///set up listeners for every notification action
    if(!(globals.listening)){

      globals.listening = true;

      AwesomeNotifications().createdStream.listen((ReceivedNotification notification) {
        print("Notification created: "+(notification.title ?? notification.body ?? notification.id.toString()));
        print(notification.summary);
      });

      AwesomeNotifications().displayedStream.listen((ReceivedNotification notification) {
        print("Notification displayed: "+(notification.title ?? notification.body ?? notification.id.toString()));
      });

      AwesomeNotifications().dismissedStream.listen((ReceivedAction dismissedAction) {
        print("Notification dismissed: "+(dismissedAction.title ?? dismissedAction.body ?? dismissedAction.id.toString()));
      });

      AwesomeNotifications().actionStream.listen((ReceivedAction action) async {
        print("Action received!");
        dev.log(action.buttonKeyPressed);

        //getPacks();
        List<HivePack> packList = loadPacks();
        packList.forEach((pack) {
          if(pack.title == action.payload!["name"]){
            pack.questions.forEach((question) {
              if(question.question == action.payload!["question"]){
                if(((action.payload!["correct"] == "0") & (action.buttonKeyPressed == "a1")) | ((action.payload!["correct"] == "1") & (action.buttonKeyPressed == "a2")) | (action.payload!["correct"] == "2") & (action.buttonKeyPressed == "a3")){
                  question.pastAnswers = correct(question.pastAnswers);
                  question.attempted += 1;
                  question.correct += 1;
                }else{
                  question.pastAnswers = incorrect(question.pastAnswers);
                  question.attempted += 1;
                }
              }
            });
          }
        });
      });
    }


    //check permissions for notification access
    if(!isNotificationsAllowed()){
      Future.delayed(Duration.zero, (){
        requestUserPermission();
      });
    }
  }






  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Home"),
        ),

        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height - 136,
                child: Stack(
                  children: [
                    ListView(
                      scrollDirection: Axis.vertical,
                      children: getPacks(),
                    ),

                    Align(
                        alignment: FractionalOffset(0.9, 0.95),
                          child: FloatingActionButton(
                            child: Icon(Icons.add),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => CreatePack(pack: Pack(enabled: true, name: "", hivePack: HivePack(title: "<NewPack>",  questions: [], enabled: true, frequency: 2),))));
                            },
                        )
                    ),
                    Align(
                      alignment: FractionalOffset(0.1, 0.95),
                      child: FloatingActionButton(
                        child: Icon(Icons.settings),
                        onPressed: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Settings()));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ),
    );
  }
}