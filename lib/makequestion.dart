import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

import 'classes.dart';
import 'globals.dart' as globals;
import 'createpack.dart';


class MakeQuestion extends StatefulWidget{
  MakeQuestion({required this.question}):super();
  Question question;

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

  @override
  void initState(){
    super.initState();
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Question Cretor"),
      ),

      body: Center(
        child: Stack(
          children: [
            Align(
              alignment: FractionalOffset(0.5, 0.4),
              child: SizedBox(
                height: 20,
                width: MediaQuery.of(context).size.width * 0.425,
                child: TextField(
                  controller: widget.qstCont,///load
                  style: TextStyle(
                  ),
                ),
              ),
            ),
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
      ),
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: FractionalOffset(0.9, 0.95),
            child: FloatingActionButton(
              child: Icon(Icons.done_rounded),
                onPressed: ()async{
                  bool textChanged = !(widget.qstCont.text == "<question>") & !(widget.ans1Cont == "<ans1>") & !(widget.ans2Cont == "<ans2>") & !(widget.ans3Cont == "<ans3>");
                  bool hasAnswer = widget.a1corr | widget.a2corr | widget.a3corr;
                  log(hasAnswer.toString());
                  log(textChanged.toString());
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
                    log(widget.question.question);
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
          Align(
            alignment: FractionalOffset(0.1, 0.95),
            child: FloatingActionButton(
              child: Icon(Icons.arrow_back_rounded),
                onPressed: (){
                  Navigator.pop(context);
                }
            ),
          ),
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