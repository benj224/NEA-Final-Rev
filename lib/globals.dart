import 'package:nea/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'classes.dart';
import 'createpack.dart';
import 'home.dart';

///seperate file used for directory wide globals variables
late Function requestUserPermission;
List<HiveQuestion> questions = [];
Question? newQuestion = null;
Pack? newPack = null;
bool listening = false;
late SharedPreferences pref;
int tabselected = 0;
final pages = [
  MyHomePage(),
  Settings(),
  CreatePack(pack: null),
];