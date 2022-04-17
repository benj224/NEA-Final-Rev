import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'globals.dart' as globals;
import 'createpack.dart';
import 'makequestion.dart';
import 'settings.dart' as settings;





List<HivePack> pcksFromJson(String _json){
  ///use the build in convert library to crete map string to dynamic
  Map map = json.decode(_json);

///itterate through each pack, question and answer building the objects from the map
  List<HivePack> packs = [];
  if(map["packs"] == null){
    map["packs"] = [];
  }
  map["packs"].forEach((pcs) {
    List<HiveQuestion> questions = [];
    pcs["questions"].forEach((qst) {
      List<HiveAnswer> answers = [];
      qst["answers"].forEach((ans) {
        answers.add(HiveAnswer(text: ans["text"], correct: ans["correct"]));
      });

      List<int> pastAns =  qst["pastAnswers"].cast<int>();

      HiveQuestion newQuestion = HiveQuestion(
        question: qst["question"],
        attempted: qst["attempted"],
        cardNo: qst["cardNo"],
        correct: qst["correct"],
        pastAnswers: pastAns,
        answers: answers,
      );

      questions.add(newQuestion);
    });

    HivePack newPack = HivePack(
      enabled: pcs["enabled"],
      frequency: pcs["frequency"],
      title: pcs["title"],
      questions: questions,
    );
    packs.add(newPack);
  });


  return packs;
}


void sendNotification(int hour, int minute, String question, String ans1, String ans2, String ans3, String correct, String packName) async {

  final prefs = await SharedPreferences.getInstance();
  DateTime tm = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, hour, minute);
  if(tm.isBefore(DateTime.now())){
    scheduleQuestions();
    return;
  }


  if(!prefs.getBool("notifications")){
    await globals.requestUserPermission();
  }

  if(!prefs.getBool("notifications")){
    return;
  }


  AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 100,
        channelKey: "basic_channel",
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

String jsonFromPacks(List<HivePack> packs){

  ///if empty return empty json object
  if(packs.length == 0){
    return "{}";
  }

  ///start with empty list packs and then add each pack itteritevley
  String output = '{"packs" : [';
  packs.forEach((pack) {
    output += pack.toJson() + ",";
  });
  output = output.substring(0, output.length -1);
  output += "]}";

  return output;
}




void deletePack(HivePack pack) async{
  ///load packs from storeage
  final prefs = await SharedPreferences.getInstance();
  String? pcks = prefs.getString("packs");
  List<HivePack> packs = [];
  if(!(pcks == null)){
    packs = pcksFromJson(pcks);
  }


  List<HivePack> outPacks = [];

  ///for every pack if the title does not match the title of the parameter pack then add to new list
  packs.forEach((element) {
    if(!(element.title == pack.title)){
      outPacks.add(element);
    }
  });

  String outJson = jsonFromPacks(outPacks);

  ///save new string to storage
  prefs.setString("packs", outJson);

}


List<Widget> loadPacks(){

///load json from storage
  String? pcks = globals.pref.getString("packs");///using globals so that function no asyncronus
  if(pcks == null){
    pcks = "{}";
  }
  List<HivePack> packs = [];
  packs = pcksFromJson(pcks);


  ///for every hive pack create a Pack
  List<Pack> outPacks = [];
  packs.forEach((pack) {
    outPacks.add(Pack(name: pack.title, hivePack: pack, enabled: pack.enabled));
  });


  ///if there are no packs return blank tile saying so
  if(outPacks.length == 0){
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

///load the packs from storeage and convert to hive pack
Future<List<HivePack>> loadHivePacks() async {
  final prefs = await SharedPreferences.getInstance();
  String? pcks = prefs.getString("packs");
  List<HivePack> packs = [];
  if(!(pcks == null)){
    packs = pcksFromJson(pcks);
  }



  return packs;
}


void addPack(HivePack pack) async{
  ///load the json from the storage
  final prefs = await SharedPreferences.getInstance();
  String? pcks = prefs.getString("packs");

  ///if the string is not null call pcks from json to load packs
  List<HivePack> packs = [];
  if(!(pcks == null)){
    packs = pcksFromJson(pcks);
  }

  ///if the pack is not allready contained in packs, add it
  if(!(packs.contains(pack))){
    packs.add(pack);
  }else{
    ///remove the old instance if one exists to replace it with updated one
    packs.removeWhere((element) => element.title == pack.title);
    packs.add(pack);
  }



  ///convert new list back to json and store
  String newPacks = jsonFromPacks(packs);
  prefs.setString("packs", newPacks);
  print("new packs: " + newPacks);
}




void scheduleQuestions() async{



  var rng = Random();


  List<HivePack> _packList = await loadHivePacks();


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
        qst = qstList.removeAt(rng.nextInt(qstList.length-1));
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


      sendNotification(DateTime.now().hour, DateTime.now().minute + 2, qst.question, qst.answers[0].text, qst.answers[1].text, qst.answers[2].text, corr, pack.title);
    }
  });
}






///class for the backend storage of data
class HivePack {
  HivePack({required this.title, required this.questions, required this.enabled, required this.frequency}) : super();

  String title;

  List<HiveQuestion> questions;

  bool enabled;

  int frequency;


  String toJson(){
    String qsts = "[";
    questions.forEach((element) {
      qsts += element.toJson() + ',';
    });
    qsts = qsts.substring(0, qsts.length -1);


    return '{"title" : ' + '"' + title + '"' + ', "questions" : ' + qsts + ']' + ', "enabled" : ' + enabled.toString() + ', "frequency" :' + frequency.toString() + '}';
  }
}


///class for the backend storage of data
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

  String toJson(){
    String answs = '[';
    answers.forEach((element) {
      answs += element.toJson() + ",";
    });
    answs = answs.substring(0, answs.length-1);
    return '{"cardNo" : ' + cardNo.toString() + ', "question" : ' + '"' + question + '"' + ', "answers" : ' + answs +']' +
    ', "attempted" : ' + attempted.toString() + ', "correct" : ' + correct.toString() + ', "pastAnswers" : ' + pastAnswers.toString() + '}';
  }

}



///class for the backend storage of data
class HiveAnswer extends HiveObject{
  HiveAnswer({required this.text, required this.correct}) : super();
  String text;
  bool correct;

  String toJson(){
    return '{"text" : ' + '"' + text + '"' + ', "correct" : ' + correct.toString() + "}";
  }
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


///calculates the color to set the question to
class _QuestionState extends State<Question>{
  Color confidence(){
    
    int total = 0;
    int max = 0;
    for(int i = 1; i < widget.pastAnswers.length; i++){
      total += (widget.pastAnswers.length-i)*(widget.pastAnswers[widget.pastAnswers.length-i]);
      max += (widget.pastAnswers.length-i)*2;
    }

    widget.progress = total/max;
    int colorValue = (total/max * 255).toInt();
    Color color = Color.fromARGB(255, 255-colorValue, colorValue, 0);

    return color;
  }


  ///updates the value displayed on the front of the pack
  void updateProgress(){
    int correct = 0;
    widget.pastAnswers.forEach((element) {
      correct += element;
    });
    widget.progress = correct/6;
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


  ///change the color depending on the enabled status
  MaterialColor isEnabled(){
    if(widget.enabled){
      return Colors.red;
    }else{
      return Colors.grey;
    }
  }


  ///get the number of questions attempted
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
      ///on long press toggle the packs enabled state
      onLongPress: (){
        setState(() {
          widget.enabled = !(widget.enabled);
          widget.hivePack.enabled = !(widget.hivePack.enabled);
        });
      },
      ///on doubble tap open create pack with the current pack loaded in to edit
      onDoubleTap: () async{
        Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePack(pack: widget)));
      },
      ///visual component of packs that gets displayed
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



///update past answers for correct answer
List<int> correct(List<int> past){
  for( var i = 1; i >= 5; i ++){
    past[i-1] = past[i];
  }
  past[5] = 0;

  return past;
}


///update past answers for incorrect value
List<int> incorrect(List<int> past){
  for( var i = 1; i >= 5; i ++){
    past[i-1] = past[i];
  }
  past[5] = 2;

  return past;
}