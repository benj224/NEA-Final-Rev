import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinbox/material.dart';

bool mon = true;
bool tue = true;
bool wed = true;
bool thur = true;
bool fri = true;
bool sat = true;
bool sun = true;

TimeOfDay startTime = TimeOfDay(hour: 7, minute: 0);
TimeOfDay endTime = TimeOfDay(hour: 22, minute: 0);

double frequency = 10;


class Settings extends StatefulWidget{


  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  void updateVal(double value){
    setState(() {
      frequency = value;
    });
  }


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
          ),
          Align(
            alignment: FractionalOffset(0.2, 0.7),
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
              alignment: FractionalOffset(0.6, 0.7),
              child: Text("Tue")
          ),
          Align(
            alignment: FractionalOffset(0.2, 0.7),
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
              alignment: FractionalOffset(0.6, 0.7),
              child: Text("Wed")
          ),
          Align(
            alignment: FractionalOffset(0.2, 0.7),
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
              alignment: FractionalOffset(0.6, 0.7),
              child: Text("Thur")
          ),
          Align(
            alignment: FractionalOffset(0.2, 0.7),
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
              alignment: FractionalOffset(0.6, 0.7),
              child: Text("Fri")
          ),
          Align(
            alignment: FractionalOffset(0.2, 0.7),
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
              alignment: FractionalOffset(0.6, 0.7),
              child: Text("Sat")
          ),
          Align(
            alignment: FractionalOffset(0.2, 0.7),
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
              alignment: FractionalOffset(0.6, 0.7),
              child: Text("Sun")
          ),

          Align(
            alignment: FractionalOffset(0.5, 0.5),
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
                child: SizedBox(),
                ///add edit icon
              )
            ),
          ),
          Align(
              alignment: FractionalOffset(0.6, 0.7),
              child: Text("Start Time: "+ startTime.hour.toString() + ":" + startTime.minute.toString())
          ),
          Align(
            alignment: FractionalOffset(0.5, 0.5),
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
                  child: SizedBox(),
                  ///add edit icon
                )
            ),
          ),
          Align(
              alignment: FractionalOffset(0.6, 0.7),
              child: Text("End Time: "+ endTime.hour.toString() + ":" + endTime.minute.toString())
          ),
          Align(
            child: SpinBox(
              min: 1,
              max: 30,
              value: frequency,
              onChanged: (value) => (){
                updateVal(value);
              },
            )
          ),
        ],
      ),
    );
  }
}