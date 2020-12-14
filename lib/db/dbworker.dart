import 'package:flutter/cupertino.dart';
import 'package:flutter_book/db/notesdbworker.dart';
import 'package:flutter_book/db/tasksdbworker.dart';
import 'package:flutter_book/tasks/tasksmodel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../notes/notesmodel.dart';
import '../utils.dart' as utils;


class DBWorker{

  NotesDBWorker notes;
  TasksDBWorker tasks;

  DBWorker._(){
    notes = NotesDBWorker();
    tasks = TasksDBWorker();
  }

  static final db = DBWorker._();


}