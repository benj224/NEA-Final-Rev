import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:nea/classes.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'createpack.dart';
import 'home.dart';
import 'globals.dart' as globals;


///add slide in animations for color picker



///initialize all variables
bool mon = true;
bool tue = true;
bool wed = true;
bool thur = true;
bool fri = true;
bool sat = true;
bool sun = true;

TimeOfDay monStartTime = TimeOfDay(hour: 7, minute: 0);
TimeOfDay monEndTime = TimeOfDay(hour: 22, minute: 0);
TimeOfDay tueStartTime = TimeOfDay(hour: 7, minute: 0);
TimeOfDay tueEndTime = TimeOfDay(hour: 22, minute: 0);
TimeOfDay wedStartTime = TimeOfDay(hour: 7, minute: 0);
TimeOfDay wedEndTime = TimeOfDay(hour: 22, minute: 0);
TimeOfDay thuStartTime = TimeOfDay(hour: 7, minute: 0);
TimeOfDay thuEndTime = TimeOfDay(hour: 22, minute: 0);
TimeOfDay friStartTime = TimeOfDay(hour: 7, minute: 0);
TimeOfDay friEndTime = TimeOfDay(hour: 22, minute: 0);
TimeOfDay satStartTime = TimeOfDay(hour: 7, minute: 0);
TimeOfDay satEndTime = TimeOfDay(hour: 22, minute: 0);
TimeOfDay sunStartTime = TimeOfDay(hour: 7, minute: 0);
TimeOfDay sunEndTime = TimeOfDay(hour: 22, minute: 0);


// create some values
Color color = Colors.red;
Color bgColor = Color(0xFF4F4F4B);

TextStyle testStyle = TextStyle(
    fontSize: 28,
    letterSpacing: 5,
    color: color,
    fontWeight: FontWeight.w300);



class Settings extends StatefulWidget{


  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {




  @override
  Widget build(context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        titleTextStyle: TextStyle(
            fontSize: 28,
            letterSpacing: 5,
            color: color,
            fontWeight: FontWeight.w300),
        automaticallyImplyLeading: false,
        title: Text("Settings"),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "DAY",
                style: TextStyle(
                    fontSize: 28,
                    letterSpacing: 5,
                    color: color,
                    fontWeight: FontWeight.w300),
              ),
              AnimatedButton(
                borderRadius: 12,
                width: 200,
                text: 'MON',
                isReverse: true,
                selectedTextColor: color,
                backgroundColor: bgColor,
                transitionType: TransitionType.LEFT_TO_RIGHT,
                onPress: () => (){
                  setState(() {
                    mon = !mon;
                  });
                },
                textStyle: TextStyle(
                    fontSize: 28,
                    letterSpacing: 5,
                    color: color,
                    fontWeight: FontWeight.w300),
                selectedBackgroundColor: Colors.white,
              ),

              AnimatedButton(
                borderRadius: 12,
                width: 200,
                text: 'TUE',
                isReverse: true,
                selectedTextColor: color,
                backgroundColor: bgColor,
                transitionType: TransitionType.LEFT_TO_RIGHT,
                onPress: () => (){
                  setState(() {
                    tue = !tue;
                  });
                },
                textStyle: TextStyle(
                    fontSize: 28,
                    letterSpacing: 5,
                    color: color,
                    fontWeight: FontWeight.w300),
                selectedBackgroundColor: Colors.white,
              ),

              AnimatedButton(
                borderRadius: 12,
                width: 200,
                text: 'WED',
                isReverse: true,
                selectedTextColor: color,
                backgroundColor: bgColor,
                transitionType: TransitionType.LEFT_TO_RIGHT,
                onPress: () => (){
                  setState(() {
                    wed = !wed;
                  });
                },
                textStyle: TextStyle(
                    fontSize: 28,
                    letterSpacing: 5,
                    color: color,
                    fontWeight: FontWeight.w300),
                selectedBackgroundColor: Colors.white,
              ),

              AnimatedButton(
                borderRadius: 12,
                width: 200,
                text: 'THU',
                isReverse: true,
                selectedTextColor: color,
                backgroundColor: bgColor,
                transitionType: TransitionType.LEFT_TO_RIGHT,
                onPress: () => (){
                  setState(() {
                    thur = !thur;
                  });
                },
                textStyle: TextStyle(
                    fontSize: 28,
                    letterSpacing: 5,
                    color: color,
                    fontWeight: FontWeight.w300),
                selectedBackgroundColor: Colors.white,
              ),

              AnimatedButton(
                borderRadius: 12,
                width: 200,
                text: 'FRI',
                isReverse: true,
                selectedTextColor: color,
                backgroundColor: bgColor,
                transitionType: TransitionType.LEFT_TO_RIGHT,
                onPress: () => (){
                  setState(() {
                    fri = !fri;
                  });
                },
                textStyle: TextStyle(
                    fontSize: 28,
                    letterSpacing: 5,
                    color: color,
                    fontWeight: FontWeight.w300),
                selectedBackgroundColor: Colors.white,
              ),

              AnimatedButton(
                borderRadius: 12,
                width: 200,
                text: 'SAT',
                isReverse: true,
                selectedTextColor: color,
                backgroundColor: bgColor,
                transitionType: TransitionType.LEFT_TO_RIGHT,
                onPress: () => (){
                  setState(() {
                    sat = !sat;
                  });
                },
                textStyle: TextStyle(
                    fontSize: 28,
                    letterSpacing: 5,
                    color: color,
                    fontWeight: FontWeight.w300),
                selectedBackgroundColor: Colors.white,
              ),

              AnimatedButton(
                borderRadius: 12,
                width: 200,
                text: 'SUN',
                isReverse: true,
                selectedTextColor: color,
                backgroundColor: bgColor,
                transitionType: TransitionType.LEFT_TO_RIGHT,
                onPress: () => (){
                  setState(() {
                    sun = !sun;
                  });
                },
                textStyle: TextStyle(
                    fontSize: 28,
                    letterSpacing: 5,
                    color: color,
                    fontWeight: FontWeight.w300),
                selectedBackgroundColor: Colors.white,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.05,
              )
            ],
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                  "START TIME",
                style: TextStyle(
                    fontSize: 28,
                    letterSpacing: 5,
                    color: color,
                    fontWeight: FontWeight.w300),
              ),
              AnimatedButton(
                borderRadius: 12,
                width: 200,
                text: monStartTime.toString().substring(10, 15),
                isReverse: true,
                selectedTextColor: color,
                backgroundColor: bgColor,
                transitionType: TransitionType.TOP_CENTER_ROUNDER,
                onPress: () => () async{
                  final TimeOfDay? newStart = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: monStartTime.hour, minute: monStartTime.minute),
                    initialEntryMode: TimePickerEntryMode.input,
                  );
                  setState(() {
                    monStartTime = newStart!;
                  });
                },
                textStyle: TextStyle(
                    fontSize: 28,
                    letterSpacing: 5,
                    color: color,
                    fontWeight: FontWeight.w300),
                selectedBackgroundColor: Colors.white,
              ),


              AnimatedButton(
                borderRadius: 12,
                width: 200,
                text: tueStartTime.toString().substring(10, 15),
                isReverse: true,
                selectedTextColor: color,
                backgroundColor: bgColor,
                transitionType: TransitionType.TOP_CENTER_ROUNDER,
                onPress: () => () async{
                  final TimeOfDay? newStart = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: tueStartTime.hour, minute: tueStartTime.minute),
                    initialEntryMode: TimePickerEntryMode.input,
                  );
                  setState(() {
                    tueStartTime = newStart!;
                  });
                },
                textStyle: TextStyle(
                    fontSize: 28,
                    letterSpacing: 5,
                    color: color,
                    fontWeight: FontWeight.w300),
                selectedBackgroundColor: Colors.white,
              ),


              AnimatedButton(
                borderRadius: 12,
                width: 200,
                text: wedStartTime.toString().substring(10, 15),
                isReverse: true,
                selectedTextColor: color,
                backgroundColor: bgColor,
                transitionType: TransitionType.TOP_CENTER_ROUNDER,
                onPress: () => () async{
                  final TimeOfDay? newStart = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: wedStartTime.hour, minute: wedStartTime.minute),
                    initialEntryMode: TimePickerEntryMode.input,
                  );
                  setState(() {
                    wedStartTime = newStart!;
                  });
                },
                textStyle: TextStyle(
                    fontSize: 28,
                    letterSpacing: 5,
                    color: color,
                    fontWeight: FontWeight.w300),
                selectedBackgroundColor: Colors.white,
              ),


              AnimatedButton(
                borderRadius: 12,
                width: 200,
                text: thuStartTime.toString().substring(10, 15),
                isReverse: true,
                selectedTextColor: color,
                backgroundColor: bgColor,
                transitionType: TransitionType.TOP_CENTER_ROUNDER,
                onPress: () => () async{
                  final TimeOfDay? newStart = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: thuStartTime.hour, minute: thuStartTime.minute),
                    initialEntryMode: TimePickerEntryMode.input,
                  );
                  setState(() {
                    thuStartTime = newStart!;
                  });
                },
                textStyle: TextStyle(
                    fontSize: 28,
                    letterSpacing: 5,
                    color: color,
                    fontWeight: FontWeight.w300),
                selectedBackgroundColor: Colors.white,
              ),

              AnimatedButton(
                borderRadius: 12,
                width: 200,
                text: friStartTime.toString().substring(10, 15),
                isReverse: true,
                selectedTextColor: color,
                backgroundColor: bgColor,
                transitionType: TransitionType.TOP_CENTER_ROUNDER,
                onPress: () => () async{
                  final TimeOfDay? newStart = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: friStartTime.hour, minute: friStartTime.minute),
                    initialEntryMode: TimePickerEntryMode.input,
                  );
                  setState(() {
                    friStartTime = newStart!;
                  });
                },
                textStyle: TextStyle(
                    fontSize: 28,
                    letterSpacing: 5,
                    color: color,
                    fontWeight: FontWeight.w300),
                selectedBackgroundColor: Colors.white,
              ),

              AnimatedButton(
                borderRadius: 12,
                width: 200,
                text: satStartTime.toString().substring(10, 15),
                isReverse: true,
                selectedTextColor: color,
                backgroundColor: bgColor,
                transitionType: TransitionType.TOP_CENTER_ROUNDER,
                onPress: () => () async{
                  final TimeOfDay? newStart = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: satStartTime.hour, minute: satStartTime.minute),
                    initialEntryMode: TimePickerEntryMode.input,
                  );
                  setState(() {
                    satStartTime = newStart!;
                  });
                },
                textStyle: TextStyle(
                    fontSize: 28,
                    letterSpacing: 5,
                    color: color,
                    fontWeight: FontWeight.w300),
                selectedBackgroundColor: Colors.white,
              ),

              AnimatedButton(
                borderRadius: 12,
                width: 200,
                text: sunStartTime.toString().substring(10, 15),
                isReverse: true,
                selectedTextColor: color,
                backgroundColor: bgColor,
                transitionType: TransitionType.TOP_CENTER_ROUNDER,
                onPress: () => () async{
                  final TimeOfDay? newStart = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: sunStartTime.hour, minute: sunStartTime.minute),
                    initialEntryMode: TimePickerEntryMode.input,
                  );
                  setState(() {
                    sunStartTime = newStart!;
                  });
                },
                textStyle: TextStyle(
                    fontSize: 28,
                    letterSpacing: 5,
                    color: color,
                    fontWeight: FontWeight.w300),
                selectedBackgroundColor: Colors.white,
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height*0.05,
              )
            ],
          ),




          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "END TIME",
                style: TextStyle(
                    fontSize: 28,
                    letterSpacing: 5,
                    color: color,
                    fontWeight: FontWeight.w300),
              ),
              AnimatedButton(
                borderRadius: 12,
                width: 200,
                text: monEndTime.toString().substring(10, 15),
                isReverse: true,
                selectedTextColor: color,
                backgroundColor: bgColor,
                transitionType: TransitionType.TOP_CENTER_ROUNDER,
                onPress: () => () async{
                  final TimeOfDay? newEnd = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: monEndTime.hour, minute: monEndTime.minute),
                    initialEntryMode: TimePickerEntryMode.input,
                  );
                  setState(() {
                    monEndTime = newEnd!;
                  });
                },
                textStyle: TextStyle(
                    fontSize: 28,
                    letterSpacing: 5,
                    color: color,
                    fontWeight: FontWeight.w300),
                selectedBackgroundColor: Colors.white,
              ),


              AnimatedButton(
                borderRadius: 12,
                width: 200,
                text: tueEndTime.toString().substring(10, 15),
                isReverse: true,
                selectedTextColor: color,
                backgroundColor: bgColor,
                transitionType: TransitionType.TOP_CENTER_ROUNDER,
                onPress: () => () async{
                  final TimeOfDay? newEnd = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: tueEndTime.hour, minute: tueEndTime.minute),
                    initialEntryMode: TimePickerEntryMode.input,
                  );
                  setState(() {
                    tueEndTime = newEnd!;
                  });
                },
                textStyle: TextStyle(
                    fontSize: 28,
                    letterSpacing: 5,
                    color: color,
                    fontWeight: FontWeight.w300),
                selectedBackgroundColor: Colors.white,
              ),


              AnimatedButton(
                borderRadius: 12,
                width: 200,
                text: wedEndTime.toString().substring(10, 15),
                isReverse: true,
                selectedTextColor: color,
                backgroundColor: bgColor,
                transitionType: TransitionType.TOP_CENTER_ROUNDER,
                onPress: () => () async{
                  final TimeOfDay? newEnd = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: wedEndTime.hour, minute: wedEndTime.minute),
                    initialEntryMode: TimePickerEntryMode.input,
                  );
                  setState(() {
                    wedEndTime = newEnd!;
                  });
                },
                textStyle: TextStyle(
                    fontSize: 28,
                    letterSpacing: 5,
                    color: color,
                    fontWeight: FontWeight.w300),
                selectedBackgroundColor: Colors.white,
              ),


              AnimatedButton(
                borderRadius: 12,
                width: 200,
                text: thuEndTime.toString().substring(10, 15),
                isReverse: true,
                selectedTextColor: color,
                backgroundColor: bgColor,
                transitionType: TransitionType.TOP_CENTER_ROUNDER,
                onPress: () => () async{
                  final TimeOfDay? newEnd = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: thuEndTime.hour, minute: thuEndTime.minute),
                    initialEntryMode: TimePickerEntryMode.input,
                  );
                  setState(() {
                    thuEndTime = newEnd!;
                  });
                },
                textStyle: TextStyle(
                    fontSize: 28,
                    letterSpacing: 5,
                    color: color,
                    fontWeight: FontWeight.w300),
                selectedBackgroundColor: Colors.white,
              ),

              AnimatedButton(
                borderRadius: 12,
                width: 200,
                text: friEndTime.toString().substring(10, 15),
                isReverse: true,
                selectedTextColor: color,
                backgroundColor: bgColor,
                transitionType: TransitionType.TOP_CENTER_ROUNDER,
                onPress: () => () async{
                  final TimeOfDay? newEnd = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: friEndTime.hour, minute: friEndTime.minute),
                    initialEntryMode: TimePickerEntryMode.input,
                  );
                  setState(() {
                    friEndTime = newEnd!;
                  });
                },
                textStyle: TextStyle(
                    fontSize: 28,
                    letterSpacing: 5,
                    color: color,
                    fontWeight: FontWeight.w300),
                selectedBackgroundColor: Colors.white,
              ),

              AnimatedButton(
                borderRadius: 12,
                width: 200,
                text: satEndTime.toString().substring(10, 15),
                isReverse: true,
                selectedTextColor: color,
                backgroundColor: bgColor,
                transitionType: TransitionType.TOP_CENTER_ROUNDER,
                onPress: () => () async{
                  final TimeOfDay? newEnd = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: satEndTime.hour, minute: satEndTime.minute),
                    initialEntryMode: TimePickerEntryMode.input,
                  );
                  setState(() {
                    satEndTime = newEnd!;
                  });
                },
                textStyle: TextStyle(
                    fontSize: 28,
                    letterSpacing: 5,
                    color: color,
                    fontWeight: FontWeight.w300),
                selectedBackgroundColor: Colors.white,
              ),

              AnimatedButton(
                borderRadius: 12,
                width: 200,
                text: sunEndTime.toString().substring(10, 15),
                isReverse: true,
                selectedTextColor: color,
                backgroundColor: bgColor,
                transitionType: TransitionType.TOP_CENTER_ROUNDER,
                onPress: () => () async{
                  final TimeOfDay? newEnd = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: sunEndTime.hour, minute: sunEndTime.minute),
                    initialEntryMode: TimePickerEntryMode.input,
                  );
                  setState(() {
                    sunEndTime = newEnd!;
                  });
                },
                textStyle: TextStyle(
                    fontSize: 28,
                    letterSpacing: 5,
                    color: color,
                    fontWeight: FontWeight.w300),
                selectedBackgroundColor: Colors.white,
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height*0.05,
              )

            ],
          ),


          Align(
            alignment: Alignment.topRight,
            child: MaterialPicker(
              portraitOnly: true,
              pickerColor: color, //default color
              onColorChanged: (Color newColor){ //on color picked
                setState(() {
                  color = newColor;
                });
              },
            ),
          ),


        ],
      ),


      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.grey.shade600,
          backgroundColor: bgColor,
          labelTextStyle: MaterialStateProperty.all(
            TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: color),
          ),
        ),
        child: NavigationBar(
          height: 65,
          selectedIndex: globals.tabselected,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          animationDuration: Duration(seconds: 2),
          onDestinationSelected: (index) {
            setState(() {
              globals.tabselected = index;
              changePage(index, context);
            });
          },
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home,
                color: color,),
              label: 'Home',
              selectedIcon: Icon(Icons.home_outlined,
                color: color,),
            ),
            NavigationDestination(
              icon: Icon(Icons.settings,
                color: color,),
              label: 'Settings',
              selectedIcon: Icon(Icons.settings_outlined,
                color: color,),
            ),
            NavigationDestination(
              icon: Icon(Icons.add,
                color: color,),
              label: 'Add',
              selectedIcon: Icon(Icons.add_outlined,
                color: color,),
            ),
          ],
        ),
      ),
    );
  }
}