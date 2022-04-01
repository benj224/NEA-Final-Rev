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
    globals.questions = widget.pack.hivePack.questions;
    /// add something for new pack check

    if(!(globals.newQuestion == null)){
      globals.questions.add(globals.newQuestion!.hiveQuestion);
      widget.pack.questions.add(globals.newQuestion!);
      log(globals.newQuestion!.question);
      globals.newQuestion = null;
    }
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
                                  pastAnswers: [1, 1, 1, 1, 1, 1],
                                  hivePack: widget.pack.hivePack),
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
                      if(globals.questions.length == 0){
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

                        List<HivePack> pcks = await packsFromHive();///not working here
                        log("didnt crash here");

                        bool isNewPack = true;
                        pcks.forEach((element) {
                          if (element.title == widget.pack.name){
                            isNewPack = false;
                          }
                        });

                        log("here still");
                        log(isNewPack.toString());
                        if(isNewPack){

                          globals.packs.add(widget.pack.hivePack);
                          Box box = await Hive.box("Globals");


                          log("here 1");
                          pcks.add(widget.pack.hivePack);
                          log("here 2");
                          box.delete("packs");
                          log("here 3");
                          box.put("packs", pcks);
                          log("here 4");

                        }else{

                          globals.packs.add(widget.pack.hivePack);
                          log(widget.pack.hivePack.title);
                        }




                       // log(pcks.length.toString());

                        globals.questions = [];

                        ///schedule questions
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => MyHomePage()));
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
                          Box box = await Hive.openBox("Globals");
                          List<dynamic> pcks = box.get("packs");
                          List<HivePack> newPcks = [];
                          //List<Widget> newDisplayPacks = [];
                          pcks.forEach((pack) {
                            if (!(pack.title == widget.pack.name)) {
                              newPcks.add(pack);
                              //newDisplayPacks.add(PackDisplay(name: pack.title, hivePack: pack));
                            }
                          });
                          box.delete("packs");
                          box.put("packs", newPcks);

                          globals.packs.removeWhere((element) => element.title == widget.pack.name);

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