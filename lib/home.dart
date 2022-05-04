import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:nea/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'globals.dart' as globals;
import 'createpack.dart';
import 'classes.dart';
import 'settings.dart' as settings;

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
                await AwesomeNotifications().requestPermissionToSendNotifications();
                bool allowed = await AwesomeNotifications().isNotificationAllowed();
                if(allowed){
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool("notifications", true);
                }
              },
            )
    );
  }



  void checkNotifications() async{
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getBool("notifications") == null){
      prefs.setBool("notifications", false);
    }
    if(!prefs.getBool("notifications")){
      Future.delayed(Duration.zero, (){
        requestUserPermission();
      });
    }
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

        ///when a notifications is answered
        List<HivePack> packList = await loadHivePacks();

        ///itterate through packs to find one with a title that matches that of the payload
        packList.forEach((pack) {
          if(pack.title == action.payload!["name"]){

            ///find the question in the pack that has the same question as the payload
            pack.questions.forEach((question) {
              if(question.question == action.payload!["question"]){

                ///if the button clicked was the correct button increase the correct count
                if(((action.payload!["correct"] == "0") & (action.buttonKeyPressed == "a1")) | ((action.payload!["correct"] == "1") & (action.buttonKeyPressed == "a2")) | (action.payload!["correct"] == "2") & (action.buttonKeyPressed == "a3")){
                  question.pastAnswers = correct(question.pastAnswers);
                  question.attempted += 1;
                  question.correct += 1;
                  deletePack(pack);
                  addPack(pack);
                }else{
                  question.pastAnswers = incorrect(question.pastAnswers);
                  question.attempted += 1;
                  deletePack(pack);
                  addPack(pack);
                }
              }
            });
          }
        });
      });
    }


    checkNotifications();


  }




  int tabselected = 0;
  final pages = [
    MyHomePage(),
    Settings(),
    CreatePack(pack: null),
  ];



  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: Text("Home"),
          titleTextStyle: TextStyle(
              fontSize: 28,
              letterSpacing: 5,
              color: color,
              fontWeight: FontWeight.w300),
        ),

        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height - 136,
                child: Stack(
                  children: [

                    ListView(
                      children: loadPacks(),
                    ),
                    ///List that will contain all the packs
                    /*FutureBuilder<List<Pack>>(
                    builder: (context, projectSnap) {
                      if (projectSnap.connectionState == ConnectionState.none && projectSnap.hasData == null) {
                        return Container();
                      }

                      List<Pack> kids = [];
                      print("data: ");
                      print(projectSnap.data);
                      if(projectSnap.data != null){
                        kids = projectSnap.data!;

                      }
                      return ListView(
                        children: kids,
                      );},
                      future: loadPacks(),
                    ),*/


                  ],
                ),
              ),
            ],
          )
        ),

      floatingActionButton: Stack(
        children: [
          Align(
            ///button to add a new pack
              alignment: FractionalOffset(0.9, 0.95),
              child: FloatingActionButton(
                backgroundColor: Colors.black,
                foregroundColor: settings.color,
                child: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CreatePack(pack: Pack(enabled: true, name: "", hivePack: HivePack(title: "<NewPack>",  questions: [], enabled: true, frequency: 2),))));
                },
              )
          ),

          Align(
            ///button to go to settings
            alignment: FractionalOffset(0.1, 0.95),
            child: FloatingActionButton(
              backgroundColor: Colors.black,
              foregroundColor: settings.color,
              child: Icon(Icons.settings),
              onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Settings()));
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.grey.shade600,
          backgroundColor: Colors.black,
          labelTextStyle: MaterialStateProperty.all(
            TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: settings.color),
          ),
        ),
        child: NavigationBar(
          height: 65,
          selectedIndex: tabselected,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          animationDuration: Duration(seconds: 2),
          onDestinationSelected: (index) {
            setState(() {
              tabselected = index;
              changePage(index, context);
            });
          },
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home,
                  color: settings.color,),
              label: 'Home',
              selectedIcon: Icon(Icons.home_outlined,
              color: settings.color,),
            ),
            NavigationDestination(
              icon: Icon(Icons.settings,
              color: settings.color,),
              label: 'Settings',
              selectedIcon: Icon(Icons.settings_outlined,
              color: settings.color,),
            ),
            NavigationDestination(
              icon: Icon(Icons.add,
              color: settings.color,),
              label: 'Add',
              selectedIcon: Icon(Icons.add_outlined,
              color: settings.color,),
            ),
          ],
        ),
      ),

    );

  }
}