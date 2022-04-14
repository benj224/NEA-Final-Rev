import 'dart:convert';
import 'dart:math';

import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'dart:developer' as dev;
//import 'package:build_runner/build_runner.dart';

import 'globals.dart' as globals;
import 'createpack.dart';
import 'makequestion.dart';
import 'settings.dart' as settings;

part 'classes.g.dart';


bool isNotificationsAllowed(){
  return true;
}

void notificationsAllowed(){

}



/*List<Widget> getPacks() async {



  final String response = await rootBundle.loadString('assets/sample.json');
  final data = await json.decode(response);

  dev.log(response);
  dev.log(data);

  /*if(outPacks.isEmpty){
    return [
      Material(
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
                child: Text("You have no Packs"),
              ),
            ],
          ),
        ),
      ),
    ];
  }*/

  return outPacks;
}*/


void deletePack(HivePack pack) async{

}


List<HivePack> loadPacks() {
  return [];
}


void addPack(HivePack pack) async{

}







void sendNotification(int hour, int minute, String question, String ans1, String ans2, String ans3, String correct, String packName) async {
  DateTime tm = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, hour, minute);
  if(tm.isBefore(DateTime.now())){
    scheduleQuestions();
    return;
  }
  dev.log("is executing");

  if(!isNotificationsAllowed()){
    await globals.requestUserPermission();
  }

  if(!isNotificationsAllowed()){
    dev.log("was false");
    return;
  }



  dev.log("Scheduled: " + tm.toString());

  await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 100,
        channelKey: "awesome_notifications",
        title: question,
        body: "test",
        payload: {"question": question, "correct": correct, "name": packName},
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


void scheduleQuestions() async{



  var rng = Random();


  List<HivePack> _packList = [];


  int earliest = settings.startTime.hour*60 + settings.startTime.minute;
  int latest = settings.endTime.hour*60 + settings.endTime.minute;

  _packList.forEach((pack) {
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


    for(int x = 0; x < pack.frequency; x++){
      HiveQuestion qst = qstList[0];
      if(qstList.length > 1){
        qst = qstList.removeAt(rng.nextInt(qstList.length)-1);
      }else{
        qst = qstList.removeAt(0);
      }

      int minutes = rng.nextInt(step) + (x * step);
      DateTime scheduleTime = DateTime.now().add(Duration(minutes: minutes + earliest));





      String corr = "";

      if(qst.answers[0].correct){
        corr = "0";
      }if(qst.answers[1].correct){
        corr = "1";
      }if(qst.answers[2].correct){
        corr = "2";
      }


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


      //if(chosenDay){
      //  sendNotification(scheduleTime.hour, scheduleTime.hour, qst.question, qst.answers[0].text, qst.answers[1].text, qst.answers[2].text, corr, pack.title);
      //}
      sendNotification(DateTime.now().hour, DateTime.now().minute + 1, qst.question, qst.answers[0].text, qst.answers[1].text, qst.answers[2].text, corr, pack.title);
    }
  });
}







class HivePack {
  HivePack({required this.title, required this.questions, required this.enabled, required this.frequency}) : super();

  String title;

  List<HiveQuestion> questions;

  bool enabled;

  int frequency;

  HivePack.fromJson(Map<String, dynamic> json)
      : title = json["title"],
        questions = List<HiveQuestion>.from(json["questions"]((model) => HiveQuestion.fromJson(model))),
        enabled = json["enabled"],
        frequency = json["frequency"];


  Map<String, dynamic> toJson() => {
    "title": title,
    "questions" : questions,
    "enabled" : enabled,
    "frequency" : frequency,
  };
}



class HiveQuestion extends HiveObject{
  HiveQuestion(
      {required this.cardNo, required this.question, required this.answers, required this.attempted, required this.correct, required this.pastAnswers})
      : super();
  int cardNo;
  String question;
  List<HiveAnswer> answers;
  int attempted;
  int correct;
  List<int> pastAnswers;


  HiveQuestion.fromJson(Map<String, dynamic> json)
  : cardNo = json["cardno"],
  question = json["question"],
  answers = List<HiveAnswer>.from(json["answers"]((model) => HiveAnswer.fromJson(model))),
  attempted = json["attempted"],
  correct = json["correct"],
  pastAnswers = json["pastanswers"];



  Map<String, dynamic> toJson() => {
    "cardno" : cardNo,
    "question" : question,
    "answers" : answers,
    "attempted" : attempted,
    "correct" : correct,
    "pastAnswers" : pastAnswers,
  };
}




class HiveAnswer extends HiveObject{
  HiveAnswer({required this.text, required this.correct}) : super();
  String text;
  bool correct;

  HiveAnswer.fromJson(Map<String, dynamic> json)
    : text = json["text"],
    correct = json["correct"];

  Map<String, dynamic> toJson() => {
    "text" : text,
    "correct" : correct,
  };
}


class Question extends StatefulWidget{
  Question({required this.cardNo, required this.question, required this.answers, required this.hiveQuestion}) : super();
  HiveQuestion hiveQuestion;
  int cardNo;
  String question;
  List<int> pastAnswers = [1,1,1,1,1,1];
  List<HiveAnswer> answers;
  double progress = 0;
  bool enabled = true;




  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question>{
  Color confidence(){
    
    int total = 0;
    int max = 0;
    for(int i = 1; i < widget.pastAnswers.length; i++){
      total += (widget.pastAnswers.length-i)*(widget.pastAnswers[widget.pastAnswers.length-i]);
      max += (widget.pastAnswers.length-i)*2;
    }

    dev.log(total.toString());

    widget.progress = total/max;
    
    int colorValue = (total/max * 255).toInt();

    dev.log(colorValue.toString());
    dev.log("color value");
    Color color = Color.fromARGB(255, 255-colorValue, colorValue, 0);

    return color;
  }

  void updateProgress(){
    int correct = 0;
    widget.pastAnswers.forEach((element) {
      correct += element;
    });
    widget.progress = correct/6;
  }

  void deleteSelf(){
    setState(() {
      globals.questions.removeWhere((question) => question.question == widget.question);
    });
  }



  @override
  void initState(){
    super.initState();
  }


  @override
  Widget build(context){
    return GestureDetector(
      onLongPress: () {
        setState(() {
          widget.enabled = !widget.enabled;
        });
      },
      onDoubleTap: (){
        ///push to question creator with question
        globals.questions.removeWhere((element) => element.question == widget.question);
        Navigator.push(context, MaterialPageRoute(builder: (context) => MakeQuestion(question: widget)));
        ///delete question
        
      },
      child: Material(
        color: confidence(),
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
        ),
        child: SizedBox(
          height: 100,
          child: Stack(
            children: [
              Align(
                alignment: FractionalOffset(0.05, 0.2),
                child: Text(widget.question),
              ),


              Align(
                alignment: FractionalOffset(0.5, 0.2),
                child: Checkbox(
                  value: widget.answers[0].correct,
                  onChanged: (bool? value){},
                ),
              ),
              Align(
                alignment: FractionalOffset(0.9, 0.2),
                child: Text(widget.answers[0].text),
              ),


              Align(
                alignment: FractionalOffset(0.5, 0.5),
                child: Checkbox(
                  value: widget.answers[1].correct,
                  onChanged: (bool? value){},
                ),
              ),
              Align(
                  alignment: FractionalOffset(0.9, 0.5),
                  child: Text(widget.answers[1].text)
              ),


              Align(
                alignment: FractionalOffset(0.5, 0.8),
                child: Checkbox(
                    value: widget.answers[2].correct,
                    onChanged: (bool? value){}
                ),
              ),
              Align(
                  alignment: FractionalOffset(0.9, 0.8),
                  child: Text(widget.answers[2].text)
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class Pack extends StatefulWidget{
  Pack({required this.name, required this.hivePack, required this.enabled}) : super();
  String name;
  HivePack hivePack;
  List<Question> questions = [];
  bool enabled;

  @override
  _PackState createState() => _PackState();

}

class _PackState extends State<Pack>{

  MaterialColor isEnabled(){
    if(widget.enabled){
      return Colors.red;
    }else{
      return Colors.grey;
    }
  }

  List questionsAttempted(){
    int qst = 0;
    int correct = 0;
    widget.hivePack.questions.forEach((element) {
      qst += element.attempted;
      correct += element.correct;
    });

    if(correct == 0){
      return [qst, correct, 0.03];
    }

    return [qst, correct, correct/qst];
  }

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onLongPress: (){
        setState(() {
          widget.enabled = !(widget.enabled);
          widget.hivePack.enabled = !(widget.hivePack.enabled);
        });
      },
      onDoubleTap: () async{
        Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePack(pack: widget)));

        dev.log("here 3");
      },
      child: Material(
        elevation: 5,
        color: isEnabled(),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
        ),
        child: SizedBox(
          height: 100,
          child: Stack(
            children: [
              Align(
                alignment: FractionalOffset(0.5, 0.1),
                child: Text(widget.name),
              ),
              Align(
                alignment: FractionalOffset(0.5, 0.65),
                child: CircularProgressIndicator(
                  strokeWidth: 6.0,
                  value: questionsAttempted()[2]/*widget.progress*/,
                ),
              ),
              Align(
                alignment: FractionalOffset(0.17, 0.25),
                child: Text("Questions: " + widget.hivePack.questions.length.toString()),
              ),
              Align(
                alignment: FractionalOffset(0.17, 0.55),
                child: Text("Attempted: " + questionsAttempted()[0].toString()),
              ),
              Align(
                alignment: FractionalOffset(0.17, 0.85),
                child: Text("Correct: " + questionsAttempted()[1].toString()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


List<int> correct(List<int> past){
  for( var i = 1; i >= 5; i ++){
    past[i-1] = past[i];
  }
  past[5] = 0;

  return past;
}

List<int> incorrect(List<int> past){
  for( var i = 1; i >= 5; i ++){
    past[i-1] = past[i];
  }
  past[5] = 2;

  return past;
}