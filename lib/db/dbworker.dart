import 'package:flutter/cupertino.dart';
import 'package:flutter_book/db/notestable.dart';
import 'package:flutter_book/db/tasksdbworker.dart';
import 'package:flutter_book/tasks/tasksmodel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../notes/notesmodel.dart';
import '../utils.dart' as utils;


class DBWorker{

  Database _db;
  NotesTable notes;


  DBWorker._(){
    notes = NotesTable(_db);
  }

  static final db = DBWorker._();

}