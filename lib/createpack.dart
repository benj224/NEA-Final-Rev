import 'dart:collection';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'classes.dart';
import 'globals.dart' as globals;
import 'home.dart';
import 'makequestion.dart';



TextEditingController titleController = TextEditingController();

class CreatePack extends StatefulWidget{
  CreatePack({required this.pack}) :super();
  final Pack pack;
  @override
  _CreatePackState createState() => _CreatePackState();
}

class _CreatePackState extends State<CreatePack> {
  //GetCards
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    widget.pack.hivePack.questions.forEach((element) {
      log(element.question);
      if(!globals.questions.contains(element)){
        globals.questions.add(element);
      }
    });

    if(!(globals.newQuestion == null)){
      if(!widget.pack.hivePack.questions.contains(globals.newQuestion!.hiveQuestion)){
        log("pack qustions didnt contain");
        widget.pack.questions.add(globals.newQuestion!);
        widget.pack.hivePack.questions.add(globals.newQuestion!.hiveQuestion);

      }
      if(!globals.questions.contains(globals.newQuestion!.hiveQuestion)){
        globals.questions.add(globals.newQuestion!.hiveQuestion);
      }
      globals.newQuestion = null;
    }
    /// add something for new pack check


    titleController.text = widget.pack.name;
  }

  List<Question> loadQuestions(){
    List<Question> outList = [];
    globals.questions.forEach((element) {
      outList.add(Question(answers: element.answers, cardNo: 0, hiveQuestion: element, question: element.question,));
      log(element.question);
    });
    return outList;
  }


  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(title: TextField(
          controller: titleController,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              hintText: "Title",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32))
          ),
        ),
          automaticallyImplyLeading: false,
        ),
        body: Stack(
          children: [
            ListView(children: loadQuestions()),



            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: FractionalOffset(0.9, 0.95),
                  child: FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        /// add new page for creating question instead.
                        widget.pack.name = titleController.text;
                        widget.pack.hivePack.title = titleController.text;
                        globals.newPack = widget.pack;
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) =>
                            MakeQuestion(question: Question(
                              hiveQuestion: HiveQuestion(question: "<question>",
                                  cardNo: 0,
                                  answers: [
                                    HiveAnswer(text: "<Ans1>", correct: false),
                                    HiveAnswer(text: "<Ans2>", correct: false),
                                    HiveAnswer(text: "<Ans3>", correct: false),
                                  ],
                                  attempted: 0,
                                  correct: 0,
                                  pastAnswers: [1, 1, 1, 1, 1, 1],),
                              answers: [
                                HiveAnswer(text: "<Ans1>", correct: false),
                                HiveAnswer(text: "<Ans2>", correct: false),
                                HiveAnswer(text: "<Ans3>", correct: false),
                              ],
                              cardNo: 0,
                              question: "<question>",),)));
                      });
                    },
                    tooltip: 'Add Item',
                  ),
                ),


                Align(
                  alignment: FractionalOffset(0.1, 0.95),
                  child: FloatingActionButton(
                    child: Icon(Icons.done_rounded),
                    onPressed: () async {
                      if(widget.pack.hivePack.questions.isEmpty){
                        showDialog(
                            context: context,
                            builder: (_) =>
                                NetworkGiffyDialog(
                                  buttonOkText: Text('Allow', style: TextStyle(color: Colors.white)),
                                  buttonOkColor: Colors.deepPurple,
                                  onlyOkButton: true,
                                  buttonRadius: 0.0,
                                  image: Image.asset("assets/images/oops.png"),
                                  title: Text('No Questions',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.w600)
                                  ),
                                  description: Text('Please add a question to this pack to save it.',
                                    textAlign: TextAlign.center,
                                  ),
                                  entryAnimation: EntryAnimation.DEFAULT,
                                  onOkButtonPressed: () async {
                                    Navigator.of(context).pop();
                                  },
                                )
                        );
                      }else{

                        widget.pack.name = titleController.text;
                        widget.pack.hivePack.title = titleController.text;



                        addPack(widget.pack.hivePack);



                       // log(pcks.length.toString());

                        globals.questions = [];

                        ///schedule questions
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => MyHomePage()));
                        log("no overflow yet");
                      }

                      ///might error cos pcks is dynamic

                    },
                    tooltip: 'Done',
                  ),
                ),
                Align(
                    alignment: FractionalOffset(0.5, 0.95),
                      child: FloatingActionButton(
                        child: Icon(Icons.delete_rounded),
                        onPressed: () async {

                          deletePack(widget.pack.hivePack);
                          globals.questions = [];

                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => MyHomePage()));
                        },
                      ),
                )
              ],
            )
          ],
        )
        // add items to the to-do list
    );
  }
}