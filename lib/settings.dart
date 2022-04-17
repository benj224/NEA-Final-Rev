import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home.dart';



///initialize all variables
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
        automaticallyImplyLeading: false,
        title: Text("Settings"),
      ),
      body: Stack(
        children: [
          ///check boxes for toggling days
          Align(
            alignment: FractionalOffset(0.05, 0.05),
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
            alignment: FractionalOffset(0.2, 0.05),
            child: Text("Mon")
          ),
          Align(
            alignment: FractionalOffset(0.05, 0.1),
            child: Checkbox(
                value: tue,
                onChanged: (bool? value){
                  setState(() {
                    tue = value!;
                  });
                }
            ),
          ),
          Align(
              alignment: FractionalOffset(0.2, 0.1),
              child: Text("Tue")
          ),
          Align(
            alignment: FractionalOffset(0.05, 0.15),
            child: Checkbox(
                value: wed,
                onChanged: (bool? value){
                  setState(() {
                    wed = value!;
                  });
                }
            ),
          ),
          Align(
              alignment: FractionalOffset(0.2, 0.15),
              child: Text("Wed")
          ),
          Align(
            alignment: FractionalOffset(0.05, 0.2),
            child: Checkbox(
                value: thur,
                onChanged: (bool? value){
                  setState(() {
                    thur = value!;
                  });
                }
            ),
          ),
          Align(
              alignment: FractionalOffset(0.2, 0.2),
              child: Text("Thur")
          ),
          Align(
            alignment: FractionalOffset(0.05, 0.25),
            child: Checkbox(
                value: fri,
                onChanged: (bool? value){
                  setState(() {
                    wed = value!;
                  });
                }
            ),
          ),
          Align(
              alignment: FractionalOffset(0.2, 0.25),
              child: Text("Fri")
          ),
          Align(
            alignment: FractionalOffset(0.05, 0.3),
            child: Checkbox(
                value: sat,
                onChanged: (bool? value){
                  setState(() {
                    sat = value!;
                  });
                }
            ),
          ),
          Align(
              alignment: FractionalOffset(0.2, 0.3),
              child: Text("Sat")
          ),
          Align(
            alignment: FractionalOffset(0.05, 0.35),
            child: Checkbox(
                value: sun,
                onChanged: (bool? value){
                  setState(() {
                    sun = value!;
                  });
                }
            ),
          ),
          Align(
              alignment: FractionalOffset(0.2, 0.35),
              child: Text("Sun")
          ),


          ///Chose minimum time
          Align(
            alignment: FractionalOffset(0.75, 0.15),
            child: GestureDetector(
              onTap: () async {
                final TimeOfDay? newStart = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(hour: startTime.hour, minute: startTime.minute),
                  initialEntryMode: TimePickerEntryMode.input,
                );

                setState(() {
                  startTime = newStart!;
                });
              },
              child: Material(
                color: Colors.red,
                child: SizedBox(
                  width: 20,
                  height: 20,
                ),
                ///add edit icon
              )
            ),
          ),
          Align(
              alignment: FractionalOffset(0.5, 0.15),
              child: Text("Start Time: "+ startTime.toString().substring(10, 15))
          ),

          ///chose maximum time
          Align(
            alignment: FractionalOffset(0.75, 0.2),
            child: GestureDetector(
                onTap: () async {
                  final TimeOfDay? newEnd = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: endTime.hour, minute: endTime.minute),
                    initialEntryMode: TimePickerEntryMode.input,
                  );

                  setState(() {
                    endTime = newEnd!;
                  });
                },
                child: Material(
                  color: Colors.red,
                  child: SizedBox(
                    width: 20,
                    height: 20,
                  ),
                  ///add edit icon
                )
            ),
          ),
          Align(
              alignment: FractionalOffset(0.5, 0.2),
              child: Text("End Time: "+ endTime.toString().substring(10, 15))
          ),


        ],
      ),

      ///button to return home
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: FractionalOffset(0.1, 0.95),
            child: FloatingActionButton(
              child: Icon(Icons.home_rounded),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
              }
            ),
          )
        ],
      ),
    );
  }
}