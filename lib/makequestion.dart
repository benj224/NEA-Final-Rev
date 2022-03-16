import 'package:flutter/material.dart';

import 'classes.dart';
import 'globals.dart' as globals;
import 'createpack.dart';


class MakeQuestion extends StatefulWidget{
  MakeQuestion({required this.question}):super();
  HiveQuestion question;

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
                  }
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
            )
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(///look at this
                onPressed: ()async{
                  widget.question.question = widget.qstCont.text;
                  widget.question.answers[0].text = widget.ans1Cont.text;
                  widget.question.answers[1].text = widget.ans2Cont.text;
                  widget.question.answers[2].text = widget.ans3Cont.text;
                  widget.question.answers[0].correct = widget.a1corr;
                  widget.question.answers[1].correct = widget.a2corr;
                  widget.question.answers[2].correct = widget.a3corr;

                  globals.newQuestion = widget.question;
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePack(pack: Pack(enabled: true, hivePack: HivePack(title: "<NewPack>",  questions: [], enabled: true, frequency: 2), name: "name",))));
                }
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton(
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