import 'classes.dart';
import 'package:hive_flutter/hive_flutter.dart';

bool notificationsAllowed = false;
late Function requestUserPermission;
List<HiveQuestion> questions = [];
List<HivePack> packs = [];
Question? newQuestion = null;
Pack? newPack = null;
bool listening = false;
late Box box;