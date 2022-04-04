import 'dart:io';

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
                  dev.log(globals.notificationsAllowed.toString());
                  globals.notificationsAllowed = globals.notificationsAllowed;
                });
              },
              onOkButtonPressed: () async {
                Navigator.of(context).pop();
                dev.log("exec 0");///probs not an issue on mobile
                await AwesomeNotifications().requestPermissionToSendNotifications();
                dev.log("exec 1");
                globals.notificationsAllowed = await AwesomeNotifications().isNotificationAllowed();
                dev.log("exec 2");
                setState(() {
                  dev.log(globals.notificationsAllowed.toString());
                  globals.notificationsAllowed = globals.notificationsAllowed;
                  dev.log(globals.notificationsAllowed.toString());
                });
              },
            )
    );
  }


  Future<List<Widget>>   getPacks() async{
    if(globals.packs.isEmpty){
      return [Material(
        elevation: 5,
        color: Colors.red,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
        ),
        child: SizedBox(
          height: 100,
          child: Stack(
            children: [
              Align(
                alignment: FractionalOffset(0.5, 0.1),
                child: Text("You Have No Packs"),
              ),
            ],
          ),
        ),
      ),];
    }else{


      Box box = await Hive.openBox("Globals");


      List<HivePack> pcks = [];
      List<dynamic> _pcks = await box.get("packs");
      _pcks.forEach((element) {
        pcks.add(element);
      });

      globals.packs = pcks;

      List<Pack> packs = [];

      globals.packs.forEach((element) {
        packs.add(Pack(enabled: true, name: element.title, hivePack: element,));
      });
      return packs;
    }

    /*List<Pack>  = [];

    globals.packs.forEach((element) {
      dev.log("element.title");
      outPacks.add(Pack(enabled: element.enabled, hivePack: element, name: element.title,));
    });*/

  }



  @override
  void initState() {

    dev.log("made it here");


    if(!(globals.listening)){

      globals.listening = true;

      AwesomeNotifications().createdStream.listen((ReceivedNotification notification) {
        print("Notification created: "+(notification.title ?? notification.body ?? notification.id.toString()));
      });

      AwesomeNotifications().displayedStream.listen((ReceivedNotification notification) {
        print("Notification displayed: "+(notification.title ?? notification.body ?? notification.id.toString()));
      });

      AwesomeNotifications().dismissedStream.listen((ReceivedAction dismissedAction) {
        print("Notification dismissed: "+(dismissedAction.title ?? dismissedAction.body ?? dismissedAction.id.toString()));
      });

      AwesomeNotifications().actionStream.listen((ReceivedAction action) async {
        print("Action received!");
        dev.log(action.buttonKeyPressed);///fk yea, use this and correct ans in payload

        getPacks();
        List<HivePack> packList = globals.packs;
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
    if(!globals.notificationsAllowed){
      Future.delayed(Duration.zero, (){
        requestUserPermission();
      });
    }

    dev.log("bruh what");

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
                    FutureBuilder(///workout how this works
                    future: getPacks(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                dev.log("snapshot had no data");
                return Center(child: CircularProgressIndicator());
              } else {
                Container(
                    child: ListView.builder(
                        itemCount: snapshot.data.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return snapshot.data;
                        }));
              }
              return Center(child: CircularProgressIndicator());
            }),
                    /*ListView(
                      children: await getPacks()
                    ),*/

                    Align(
                        alignment: FractionalOffset(0.9, 0.95),
                          child: FloatingActionButton(
                            child: Icon(Icons.add),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => CreatePack(pack: Pack(enabled: true, name: "name", hivePack: HivePack(title: "<NewPack>",  questions: [], enabled: true, frequency: 2),))));
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