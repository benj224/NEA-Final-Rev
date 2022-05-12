import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:nea/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'globals.dart' as globals;
import 'createpack.dart';
import 'classes.dart';
import 'home.dart';
import 'settings.dart' as settings;

///changes to make
///load all packs from hive in main function
///only save all packs to hive on done pack button.
///simplify buttons to use delete self method

class ServerPage extends StatefulWidget{
  @override
  _ServerPageState createState() => _ServerPageState();




}

class _ServerPageState extends State<ServerPage> {



  @override
  void initState() {

  }




  int tabselected = 0;
  final pages = [
    MyHomePage(),
    Settings(),
    CreatePack(pack: null),
  ];



  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        automaticallyImplyLeading: false,
        title: Text("NET"),
        titleTextStyle: TextStyle(
            fontSize: 28,
            letterSpacing: 5,
            color: color,
            fontWeight: FontWeight.w300),
      ),

      body: Center(
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height - 136,
                child: Stack(
                  children: [

                    ListView(
                      children: loadPacks(),
                    ),
                    ///List that will contain all the packs
                    /*FutureBuilder<List<Pack>>(
                    builder: (context, projectSnap) {
                      if (projectSnap.connectionState == ConnectionState.none && projectSnap.hasData == null) {
                        return Container();
                      }

                      List<Pack> kids = [];
                      print("data: ");
                      print(projectSnap.data);
                      if(projectSnap.data != null){
                        kids = projectSnap.data!;

                      }
                      return ListView(
                        children: kids,
                      );},
                      future: loadPacks(),
                    ),*/


                  ],
                ),
              ),
            ],
          )
      ),

      /*floatingActionButton: Stack(
        children: [
          Align(
            ///button to add a new pack
              alignment: FractionalOffset(0.9, 0.95),
              child: FloatingActionButton(
                backgroundColor: bgColor,
                foregroundColor: settings.color,
                child: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CreatePack(pack: Pack(enabled: true, name: "", hivePack: HivePack(title: "<NewPack>",  questions: [], enabled: true, frequency: 2),))));
                },
              )
          ),

          Align(
            ///button to go to settings
            alignment: FractionalOffset(0.1, 0.95),
            child: FloatingActionButton(
              backgroundColor: bgColor,
              foregroundColor: settings.color,
              child: Icon(Icons.settings),
              onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Settings()));
              },
            ),
          ),
        ],
      ),*/

      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.grey.shade600,
          backgroundColor: bgColor,
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