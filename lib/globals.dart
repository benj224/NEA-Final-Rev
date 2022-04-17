import 'package:shared_preferences/shared_preferences.dart';
import 'classes.dart';

///seperate file used for directory wide globals variables
late Function requestUserPermission;
List<HiveQuestion> questions = [];
Question? newQuestion = null;
Pack? newPack = null;
bool listening = false;
late SharedPreferences pref;