import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:build_runner/build_runner.dart';

import 'globals.dart' as globals;
import 'createpack.dart';
import 'makequestion.dart';

part 'classes.g.dart';




@HiveType(typeId: 10)
class HivePack extends HiveObject{
  HivePack({required this.title, required this.questions, required this.enabled, required this.frequency}) : super();
  @HiveField(11)
  final String title;
  @HiveField(12)
  final List<HiveQuestion> questions;
  @HiveField(13)
  bool enabled;
  @HiveField(14)
  int frequency;
}



@HiveType(typeId: 20)
class HiveQuestion extends HiveObject{
  HiveQuestion(
      {required this.cardNo, required this.question, required this.answers, required this.attempted, required this.correct, required this.pastAnswers, required this.hivePack})
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
  @HiveField(27)
  final HivePack hivePack;
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
  final HiveQuestion hiveQuestion;
  final int cardNo;
  String question;
  List<int> pastAnswers = [1,1,1,1,1,1];
  final List<HiveAnswer> answers;
  double progress = 0;
  bool enabled = true;




  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question>{
  MaterialColor confidence(){
    if(!widget.enabled){
      return Colors.grey;
    }
    int noCorrect = 0;
    widget.pastAnswers.forEach((element) {
      noCorrect += 1;
    });

    if(noCorrect <= 4){
      return Colors.red;
    }if(noCorrect <= 2){
      return Colors.orange;
    }

    return Colors.green;
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


  void schedule(){
    AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 100,
          channelKey: "awesome_notifications",
          title: "Question:",
          body: widget.question,
          //notificationLayout: NotificationLayout.BigPicture,
          //largeIcon: "https://avidabloga.files.wordpress.com/2012/08/emmemc3b3riadeneilarmstrong3.jpg",
          //bigPicture: "https://www.dw.com/image/49519617_303.jpg",
          showWhen: true,
          payload: {
            "packname":widget.hiveQuestion.hivePack.title,
            "question":widget.question
          }
      ),
      actionButtons: [
        NotificationActionButton(
          key: "a1",
          label: widget.answers[0].text,
          enabled: true,
          buttonType: ActionButtonType.Default,
        ),
        NotificationActionButton(
          key: "a2",
          label: widget.answers[1].text,
          enabled: true,
          buttonType: ActionButtonType.Default,
        ),
        NotificationActionButton(
          key: "a3",
          label: widget.answers[2].text,
          enabled: true,
          buttonType: ActionButtonType.Default,
        )
      ],
    );
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => MakeQuestion(question: widget)));
        ///delete question
        globals.questions.remove(widget);
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
  final String name;
  final HivePack hivePack;
  final List<Question> questions = [];
  bool enabled;

  @override
  _PackState createState() => _PackState();

  void deleteSelf() {
    globals.packs.removeWhere((pack) => pack.name == this.name);
  }
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
        Box box = await Hive.openBox("Globals");
        await box.put("editbox", widget.hivePack);
        Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePack(pack: widget)));
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