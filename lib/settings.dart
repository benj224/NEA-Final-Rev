import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool mon = true;
bool tue = true;
bool wed = true;
bool thur = true;
bool fri = true;
bool sat = true;
bool sun = true;

TimeOfDay startTime = TimeOfDay(hour: 7, minute: 0);
TimeOfDay endTime = TimeOfDay(hour: 22, minute: 0);


class Settings extends StatefulWidget{


  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {


  @override
  Widget build(context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Stack(
        children: [
          Align(
            alignment: FractionalOffset(0.2, 0.7),
            child: Checkbox(
                value: mon,
                onChanged: (bool? value){
                  setState(() {
                    mon = value!;
                  });
                }
            ),
          ),
          Align(
            alignment: FractionalOffset(0.6, 0.7),
            child: Text("Mon")
          )
        ],
      ),
    );
  }
}