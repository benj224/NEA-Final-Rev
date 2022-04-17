import 'dart:math';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:workmanager/workmanager.dart';



import 'globals.dart' as globals;
import 'settings.dart' as settings;
import 'classes.dart';
import 'home.dart';



///TODO add sort by filter
///TODO sort settings page
///



void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {

    var rng = Random();

    List<HivePack> _packList = await loadHivePacks();

    ///get the earliest and latest times the packs will schedule from settings
    int earliest = settings.startTime.hour*60 + settings.startTime.minute;
    int latest = settings.endTime.hour*60 + settings.endTime.minute;

    ///itterate through the packs adding to a list for each past wrong answer
    _packList.forEach((pack) async {
      List<HiveQuestion> qstList = [];
      pack.questions.forEach((question) {
        int score = 0;
        for(int i = 0; i < 6; i++){
          score += question.pastAnswers[i] * (i + 1);
        }
        for(int n = 0; n < score; n++){
          qstList.add(question);
        }
      });



      int step = ((latest - earliest)/pack.frequency).toInt();



      ///remove frequency many questions to be asked
      for(int x = 0; x < pack.frequency; x++){
        HiveQuestion qst = qstList[0];
        if(qstList.length > 1){
          qst = qstList.removeAt(rng.nextInt(qstList.length-1));
        }else{
          qst = qstList.removeAt(0);
        }

        int minutes = rng.nextInt(step) + (x * step);
        DateTime scheduleTime = DateTime.now().add(Duration(minutes: minutes + earliest));



        ///method of conveying the correct answer by string in the notifion payload
        String corr = "";

        if(qst.answers[0].correct){
          corr = "0";
        }if(qst.answers[1].correct){
          corr = "1";
        }if(qst.answers[2].correct){
          corr = "2";
        }



        ///check if the user wants questions on the day
        bool chosenDay = false;
        if(DateTime.now().weekday == 1){
          chosenDay = settings.mon;
        }if(DateTime.now().weekday == 2){
          chosenDay = settings.tue;
        }if(DateTime.now().weekday == 3){
          chosenDay = settings.wed;
        }if(DateTime.now().weekday == 4){
          chosenDay = settings.thur;
        }if(DateTime.now().weekday == 5){
          chosenDay = settings.fri;
        }if(DateTime.now().weekday == 6){
          chosenDay = settings.sat;
        }if(DateTime.now().weekday == 7){
          chosenDay = settings.sun;
        }


        if(!chosenDay){
          return;
        }


        ///check the time is not allready passed
        scheduleTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, DateTime.now().minute + 2);
        final prefs = await SharedPreferences.getInstance();
        DateTime tm = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, DateTime.now().minute + 2);
        if(tm.isBefore(DateTime.now())){
          scheduleQuestions();
          return;
        }


        ///check for notificaion permisions before sending
        if(!prefs.getBool("notifications")){
          await globals.requestUserPermission();
        }

        if(!prefs.getBool("notifications")){
          return;
        }



        ///schedule the notification
        AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: rng.nextInt(100000),
        channelKey: "awesome_notifications",
        title: qst.question,
        body: "test",
        payload: {"question": qst.question, "correct": corr, "name": pack.title},
        showWhen: true,
      ),
      actionButtons: [
        NotificationActionButton(
          key: "a1",
          label: qst.answers[0].text,
          enabled: true,
          buttonType: ActionButtonType.Default,
        ),
        NotificationActionButton(
          key: "a2",
          label:  qst.answers[1].text,
          enabled: true,
          buttonType: ActionButtonType.Default,
        ),
        NotificationActionButton(
          key: "a3",
          label:  qst.answers[2].text,
          enabled: true,
          buttonType: ActionButtonType.Default,
        )
      ],
      schedule: NotificationCalendar.fromDate(date: scheduleTime)
        );
      }
    });
    return Future.value(true);
  });
}


void main() async {

  ///Initialize the awesome notifications service and create a channel for us to create notifications on
  bool done = await AwesomeNotifications().initialize(
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



///baisc backend permission check
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });



///initialize the service for storing persistent data
  final prefs = await SharedPreferences.getInstance();
  globals.pref = prefs;




///initialize the service for running background tasks
  Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false
  );


///schedule the task every midnight from now
  Duration TTM = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0, 0).add(Duration(days: 1)).difference(DateTime.now());
  Workmanager().registerPeriodicTask(
      "scheduleQuestions",
      "scheduleQuestions",
      initialDelay: TTM,
      frequency: Duration(days: 1)
  );




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

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

