import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'classes.dart';
import 'globals.dart' as globals;
import 'home.dart';



TextEditingController titleController = TextEditingController();

class CreatePack extends StatefulWidget{
  CreatePack({required this.pack}) :super();
  final Pack pack;
  @override
  _CreatePackState createState() => _CreatePackState();
}

class _CreatePackState extends State<CreatePack>{//GetCards
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    globals.questions = widget.pack.questions;
  }


  @override
  Widget build(context){
    return Scaffold(
        appBar: AppBar(title: TextField(
          controller: titleController,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              hintText: "Title",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32))
          ),
        ),),
        body: ListView(children: globals.questions),
        // add items to the to-do list
        floatingActionButton:Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                  onPressed: (){
                    setState(() {
                      /// add new page for creating question instead.
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MakeQuestion(question: HiveQuestion(question: "<question>", cardNo: 0, answers: [
                        HiveAnswer(text: "<Ans1>", correct: false),
                        HiveAnswer(text: "<Ans2>", correct: false),
                        HiveAnswer(text: "<Ans3>", correct: false),
                      ], attempted: 0, correct: 0, pastAnswers: [1,1,1,1,1,1], hivePack: widget.pack),)));///fix
                    });
                  },
                  tooltip: 'Add Item',
                  child: Icon(Icons.add)),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton(
                  onPressed: () async{

                    List<HiveQuestion> Qst = [];
                    int cardNo = 0;
                    globals.questions.forEach((question) => {
                      Qst.add(question.hiveQuestion),
                      cardNo += 1
                    });

                    HivePack pck = HivePack(title: titleController.text, questions: Qst, enabled: true, frequency: 2);
                    Box box = await Hive.openBox("Globals");
                    if(!(box.get("editbox") == null)){
                      List<dynamic> pcks = box.get("packs");
                      HivePack? removePack = null;
                      List<HivePack> newPck = [];
                      pcks.forEach((pack) {
                        if(!(pack == box.get("editbox"))){
                          newPck.add(pack);
                        }
                      });
                      box.delete("packs");
                      box.put("packs", newPck);
                    }

                    if(box.get("packs") == null){
                      List<HivePack> PackList = [pck];
                      box.put("packs", PackList);
                    }else{
                      List PackList = box.get("packs");
                      List<HivePack> _packList = PackList.cast<HivePack>();
                      _packList.add(pck);
                      box.delete("packs");
                      await box.put("packs", _packList);
                    }


                    if(box.get("titles") == null){
                      List<String> _titleList = [titleController.text];
                      box.put("titles", _titleList);
                    }else{
                      List titleList = box.get("titles");
                      List<String> _titleList = titleList.cast<String>();
                      _titleList.add(titleController.text);
                      box.delete("titles");
                      await box.put("titles", _titleList);
                    }
                    globals.questions = [];

                    ///schedule questions
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
                  },
                  tooltip: 'Done',
                  child: Icon(Icons.offline_pin)),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                onPressed: () async{

                  Box box = await Hive.openBox("Globals");
                  List<dynamic> pcks = box.get("packs");
                  List<HivePack> newPcks = [];
                  List<String> newTitles = [];
                  //List<Widget> newDisplayPacks = [];
                  pcks.forEach((pack) {
                    if(!(pack.title == widget.pack.name)){
                      newPcks.add(pack);
                      newTitles.add(pack.title);
                      //newDisplayPacks.add(PackDisplay(name: pack.title, hivePack: pack));
                    }
                  });
                  box.delete("packs");
                  box.put("packs", newPcks);
                  box.delete("titles");
                  box.put("titles", newTitles);

                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
                },
              ),
            )
          ],
        )
    );
  }