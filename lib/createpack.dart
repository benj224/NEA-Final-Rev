import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:nea/settings.dart' as settings;

import 'classes.dart';
import 'globals.dart' as globals;
import 'globals.dart';
import 'home.dart';
import 'makequestion.dart';


///implement bottom bar



TextEditingController titleController = TextEditingController();

class CreatePack extends StatefulWidget{
  CreatePack({required this.pack}) :super();
  Pack? pack;
  @override
  _CreatePackState createState() => _CreatePackState();
}

class _CreatePackState extends State<CreatePack> {
  //GetCards
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if(widget.pack == null){
      widget.pack = Pack(enabled: true, name: "Title", hivePack: HivePack(enabled: true, frequency: 4, questions: [], title: "Title"),);
    }

    ///if the page opened from an existing pack load the questions into the list view
    widget.pack!.hivePack.questions.forEach((element) {
      log(element.question);
      if(!globals.questions.contains(element)){
        globals.questions.add(element);
      }
    });


    ///if a question has just been crated load the question into the packs questions
    if(!(globals.newQuestion == null)){
      if(!widget.pack!.hivePack.questions.contains(globals.newQuestion!.hiveQuestion)){
        log("pack qustions didnt contain");
        widget.pack!.questions.add(globals.newQuestion!);
        widget.pack!.hivePack.questions.add(globals.newQuestion!.hiveQuestion);

      }
      if(!globals.questions.contains(globals.newQuestion!.hiveQuestion)){
        globals.questions.add(globals.newQuestion!.hiveQuestion);
      }
      globals.newQuestion = null;
    }


    ///when editing existing pack set the title controller to the pack title
    titleController.text = widget.pack!.name;
  }


  ///Load packs from the database form of HivePack to a widget form of Pack
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
      ///top app bar with title box in
        appBar: AppBar(title: TextField(
          style: TextStyle(color: Colors.white, fontSize: 18),
          controller: titleController,
          decoration: InputDecoration(
            fillColor: Colors.white,
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
            SpinBox(
              min: 1,
              max: 30,
              value: 6,
              step: 1,
              onChanged: (value) {
                widget.pack!.hivePack.frequency = value.toInt();
              }
            ),
            ///List of questions
            ListView(children: loadQuestions()),
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: FractionalOffset(0.9, 0.95),

                  ///button to add new question
                  child: FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        widget.pack!.name = titleController.text;
                        widget.pack!.hivePack.title = titleController.text;
                        globals.newPack = widget.pack;
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) =>
                            MakeQuestion(question: Question(
                              hiveQuestion: HiveQuestion(question: "",
                                  cardNo: 0,
                                  answers: [
                                    HiveAnswer(text: "", correct: false),
                                    HiveAnswer(text: "", correct: false),
                                    HiveAnswer(text: "", correct: false),
                                  ],
                                  attempted: 0,
                                  correct: 0,
                                  pastAnswers: [1, 1, 1, 1, 1, 1],),
                              answers: [
                                HiveAnswer(text: "", correct: false),
                                HiveAnswer(text: "", correct: false),
                                HiveAnswer(text: "", correct: false),
                              ],
                              cardNo: 0,
                              question: "",),)));
                      });
                    },
                    tooltip: 'Add Item',
                  ),
                ),


                ///save the pack and go back to the home page
                Align(
                  alignment: FractionalOffset(0.1, 0.95),
                  child: FloatingActionButton(
                    child: Icon(Icons.done_rounded),
                    onPressed: () async {
                      if(widget.pack!.hivePack.questions.isEmpty || titleController.text == ""){
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

                        widget.pack!.name = titleController.text;
                        widget.pack!.hivePack.title = titleController.text;

                        deletePack(widget.pack!.hivePack);
                        addPack(widget.pack!.hivePack);

                        globals.questions = [];

                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => MyHomePage()));
                        log("no overflow yet");
                      }
                    },
                    tooltip: 'Done',
                  ),
                ),

                ///delete the pack and go back to home page
                Align(
                    alignment: FractionalOffset(0.5, 0.95),
                      child: FloatingActionButton(
                        child: Icon(Icons.delete_rounded),
                        onPressed: () async {

                          deletePack(widget.pack!.hivePack);
                          globals.questions = [];

                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => MyHomePage()));
                        },
                      ),
                )
              ],
            )
          ],
        ),

      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.grey.shade600,
          backgroundColor: settings.bgColor,
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