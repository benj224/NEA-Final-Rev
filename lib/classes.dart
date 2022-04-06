import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'dart:developer' as dev;
//import 'package:build_runner/build_runner.dart';

import 'globals.dart' as globals;
import 'createpack.dart';
import 'makequestion.dart';

part 'classes.g.dart';


bool isNotificationsAllowed(){
  Box box = Hive.box("Permissions");

  bool allowed = box.get("notifications", defaultValue: false);
  return allowed;
}

void notificationsAllowed(){
  Box box = Hive.box("Permissions");
  box.put("notifications", true);
}



List<Widget> getPacks(){
  Box box = Hive.box<List>("Globals");
  List<HivePack> packs = box.get("packs", defaultValue: <HivePack>[]).cast<HivePack>();
  dev.log("packs length " + packs.length.toString());

  List<Pack> outPacks = [];

  packs.forEach((element) {
    outPacks.add(Pack(enabled: true, name: element.title, hivePack: element,));
  });

  if(outPacks.isEmpty){
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
  }

  return outPacks;
}


void deletePack(HivePack pack){
  Box box = Hive.box<List>("Globals");
  List<HivePack> packs = box.get("packs", defaultValue: <HivePack>[]).cast<HivePack>();

  packs.removeWhere((element) => element == pack);

  box.put("packs", packs);
}


List<HivePack> loadPacks(){
  Box box = Hive.box<List>("Globals");
  List<HivePack> packs = box.get("packs", defaultValue: <HivePack>[]).cast<HivePack>();
  return packs;
}


void addPack(HivePack pack) async{
  Box box = Hive.box<List>("Globals");
  List<HivePack> packs = box.get("packs", defaultValue: <HivePack>[]).cast<HivePack>();
  dev.log("before adding " + packs.length.toString());



  if(!packs.contains(pack)){
    packs.add(pack);
  }


  dev.log("before putting " + packs.length.toString());
  await box.put("packs", packs);
}







void sendNotification(int hour, int minute, String question, String ans1, String ans2, String ans3, String correct, String packName) async {
  dev.log("is executing");

  if(!isNotificationsAllowed()){
    await globals.requestUserPermission();
  }

  if(!isNotificationsAllowed()){
    dev.log("was false");
    return;
  }
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

  late Box box;
  if(Hive.isBoxOpen("Globals")){
    box = Hive.box<List>("Globals");
  }else{
    box = await Hive.openBox<List>("Globals");
  }

  List<HivePack> _packList = box.get("packs", defaultValue: <HivePack>[]).cast<HivePack>();
  dev.log(_packList.length.toString());
  _packList.forEach((pack) {
    List<HiveQuestion> qstList = [];
    dev.log("question list length");
    dev.log(pack.questions.length.toString());
    pack.questions.forEach((question) {
      dev.log(question.question);
      int score = 0;
      for(int i = 0; i < 6; i++){
        dev.log("boom");
        score += question.pastAnswers[i] * 6;
      }
      dev.log("score: ");
      dev.log(score.toString());
      for(int n = 0; n < score; n++){
        dev.log("pow");
        qstList.add(question);
      }
    });
    double hourIndex = 14/pack.frequency;
    for(int x = 0; x < pack.frequency; x++){
      HiveQuestion qst = qstList[0];
      if(qstList.length > 1){
        HiveQuestion qst = qstList.removeAt(rng.nextInt(qstList.length)-1);
      }else{
        HiveQuestion qst = qstList.removeAt(0);
      }

      int earliest = x*hourIndex.toInt()*60;
      int latest = (x+1)*hourIndex.toInt()*60;
      int min = rng.nextInt(latest-earliest) + earliest;
      int hours = min ~/ 60;
      int mins = min % 60;

      dev.log(hours.toString() + " : " + mins.toString() );

      String corr = "";

      if(qst.answers[0].correct){
        corr = "0";
      }if(qst.answers[1].correct){
        corr = "1";
      }if(qst.answers[2].correct){
        corr = "2";
      }


      dev.log("scheduled notificatons");
      sendNotification(hours, mins, qst.question, qst.answers[0].text, qst.answers[1].text, qst.answers[2].text, corr, pack.title);
      //sendNotification(DateTime.now().hour, DateTime.now().minute + 1, qst.question, qst.answers[0].text, qst.answers[1].text, qst.answers[2].text, corr, pack.title);
    }
  });
}






@HiveType(typeId: 10)
class HivePack extends HiveObject{
  HivePack({required this.title, required this.questions, required this.enabled, required this.frequency}) : super();
  @HiveField(11)
  String title;
  @HiveField(12)
  List<HiveQuestion> questions;
  @HiveField(13)
  bool enabled;
  @HiveField(14)
  int frequency;
}



@HiveType(typeId: 20)
class HiveQuestion extends HiveObject{
  HiveQuestion(
      {required this.cardNo, required this.question, required this.answers, required this.attempted, required this.correct, required this.pastAnswers})
      : super();
  @HiveField(21)
  int cardNo;///probs change this
  @HiveField(22)
  String question;
  @HiveField(23)
  List<HiveAnswer> answers;
  @HiveField(24)
  int attempted;
  @HiveField(25)
  int correct;
  @HiveField(26)
  List<int> pastAnswers;
}



@HiveType(typeId: 30)
class HiveAnswer extends HiveObject{
  HiveAnswer({required this.text, required this.correct}) : super();
  @HiveField(31)
  String text;
  @HiveField(32)
  bool correct;
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