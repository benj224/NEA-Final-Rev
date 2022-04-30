import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

import 'classes.dart';
import 'globals.dart' as globals;
import 'createpack.dart';


class MakeQuestion extends StatefulWidget{
  MakeQuestion({required this.question}):super();
  Question question;

  ///instantiate the variables used for the fields
  TextEditingController qstCont = TextEditingController();
  TextEditingController ans1Cont = TextEditingController();
  TextEditingController ans2Cont = TextEditingController();
  TextEditingController ans3Cont = TextEditingController();
  bool a1corr = false;
  bool a2corr = false;
  bool a3corr = false;
  @override
  _MakeQuestionState createState() => _MakeQuestionState();
}




class _MakeQuestionState extends State<MakeQuestion> {


  ///populates the boxes to show the past answers
  List<Widget> showPastAns(){
    List<Widget> outBoxes = [];
    outBoxes.add(Text("Past Answers: "));
    widget.question.hiveQuestion.pastAnswers.forEach((element) {
      if(element == 2){
        outBoxes.add(Checkbox(value: true, onChanged: null));
      }else{
        outBoxes.add(Checkbox(value: false, onChanged: null));
      }
    });

    return outBoxes;
  }

  @override
  void initState(){
    super.initState();
    ///if edititng and exitsing question load values in
    widget.qstCont.text = widget.question.question;
    widget.ans1Cont.text = widget.question.answers[0].text;
    widget.ans2Cont.text = widget.question.answers[1].text;
    widget.ans3Cont.text = widget.question.answers[2].text;
    widget.a1corr = widget.question.answers[0].correct;
    widget.a2corr = widget.question.answers[1].correct;
    widget.a3corr = widget.question.answers[2].correct;

  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      ///top bar with question field
      appBar: AppBar(title: TextField(
        style: TextStyle(color: Colors.white, fontSize: 18),
        controller: widget.qstCont,
        decoration: InputDecoration(
            fillColor: Colors.white,
            contentPadding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            hintText: "Question",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32))
        ),
      ),
        automaticallyImplyLeading: false,
      ),

      body: Center(
        child: Container(
          width: 0.95*MediaQuery.of(context).size.width,
          alignment: FractionalOffset(0.5, 0),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ///display the past answers
                  Row(
                      children: showPastAns()
                  ),

                  ///show the times attempted and correct
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Times Attempted: " + widget.question.hiveQuestion.attempted.toString()),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Times Correct: " + widget.question.hiveQuestion.correct.toString()),
                  ),

                  ///check boxes and text fields for 3 answers
                  Row(
                    children: [
                      Align(
                        alignment: FractionalOffset(0.2, 0.5),
                        child: Checkbox(
                          value: widget.a1corr,
                          onChanged: (bool? value){
                            setState(() {
                              widget.a1corr = value!;
                            });
                          },
                        ),
                      ),
                      Align(
                        alignment: FractionalOffset(0.6, 0.5),
                        child: SizedBox(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.425,
                          child: TextField(
                            controller: widget.ans1Cont,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                hintText: "Answer 1",
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32))
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Align(
                        alignment: FractionalOffset(0.2, 0.6),
                        child: Checkbox(
                          value: widget.a2corr,
                          onChanged: (bool? value){
                            setState(() {
                              widget.a2corr = value!;
                            });
                          },
                        ),
                      ),
                      Align(
                        alignment: FractionalOffset(0.6, 0.6),
                        child: SizedBox(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.425,
                          child: TextField(
                            controller: widget.ans2Cont,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                hintText: "Answer 2",
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32))
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Align(
                        alignment: FractionalOffset(0.2, 0.7),
                        child: Checkbox(
                          value: widget.a3corr,
                          onChanged: (bool? value){
                            setState(() {
                              widget.a3corr = value!;
                            });
                          },
                        ),
                      ),
                      Align(
                        alignment: FractionalOffset(0.6, 0.7),
                        child: SizedBox(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.425,
                          child: TextField(
                            controller: widget.ans3Cont,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                hintText: "Answer 3",
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32))
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ],
          ),
        )
      ),




      floatingActionButton: Stack(
        children: [
          ///button to save question and go back to make pack page
          Align(
            alignment: FractionalOffset(0.9, 0.95),
            child: FloatingActionButton(
              child: Icon(Icons.done_rounded),
                onPressed: ()async{
                  bool textChanged = !(widget.qstCont.text == "") & !(widget.ans1Cont == "") & !(widget.ans2Cont == "") & !(widget.ans3Cont == "");
                  bool hasAnswer = widget.a1corr | widget.a2corr | widget.a3corr;
                  if(textChanged & hasAnswer){
                    widget.question.question = widget.qstCont.text;
                    widget.question.answers[0].text = widget.ans1Cont.text;
                    widget.question.answers[1].text = widget.ans2Cont.text;
                    widget.question.answers[2].text = widget.ans3Cont.text;
                    widget.question.answers[0].correct = widget.a1corr;
                    widget.question.answers[1].correct = widget.a2corr;
                    widget.question.answers[2].correct = widget.a3corr;


                    widget.question.hiveQuestion.question = widget.qstCont.text;
                    widget.question.hiveQuestion.answers[0].text = widget.ans1Cont.text;
                    widget.question.hiveQuestion.answers[1].text = widget.ans2Cont.text;
                    widget.question.hiveQuestion.answers[2].text = widget.ans3Cont.text;
                    widget.question.hiveQuestion.answers[0].correct = widget.a1corr;
                    widget.question.hiveQuestion.answers[1].correct = widget.a2corr;
                    widget.question.hiveQuestion.answers[2].correct = widget.a3corr;

                    globals.newQuestion = widget.question;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePack(pack:  globals.newPack!)));
                  }else{
                    showDialog(
                        context: context,
                        builder: (_) =>
                            NetworkGiffyDialog(
                              buttonOkText: Text('Allow', style: TextStyle(color: Colors.white)),
                              onlyOkButton: true,
                              buttonOkColor: Colors.blue,
                              image: Image.asset("assets/images/oops.png"),
                              buttonRadius: 0.0,
                              title: Text('Information Missing',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w600)
                              ),
                              description: Text('Please make sure all the fields are filled and an answer is chosen',
                                textAlign: TextAlign.center,
                              ),
                              entryAnimation: EntryAnimation.DEFAULT,
                              onOkButtonPressed: () async {
                                Navigator.of(context).pop();
                              },
                            )
                    );
                  }
                }
            ),
          ),

          ///go back to create pack page without saving changes
          Align(
            alignment: FractionalOffset(0.1, 0.95),
            child: FloatingActionButton(
              child: Icon(Icons.arrow_back_rounded),
                onPressed: (){
                  Navigator.pop(context);
                }
            ),
          ),

          ///delete question and retrun to create pack page
          Align(
            alignment: FractionalOffset(0.5, 0.95),
            child: FloatingActionButton(
                child: Icon(Icons.delete_rounded),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePack(pack: Pack(enabled: true, hivePack: HivePack(title: "<NewPack>",  questions: [], enabled: true, frequency: 2), name: "name",))));
                }
            ),
          )
        ],
      ),
    );
  }
}