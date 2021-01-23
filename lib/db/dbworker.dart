import 'package:flutter/cupertino.dart';
import 'package:flutter_book/db/appointmentstable.dart';
import 'package:flutter_book/db/contactstable.dart';
import 'package:flutter_book/db/notestable.dart';
import 'package:flutter_book/db/taskstable.dart';
import 'package:flutter_book/models/tasksmodel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/notesmodel.dart';
import '../utils.dart' as utils;


class DBWorker{

  Database _db;
  NotesTable notes;
  TasksTable tasks;
  AppointmentsTable appointments;
  ContactsTable contacts;


  static Future<Database> init()async{
    var path = join(utils.docsDir.path, 'newestDb.db');
    Database db = await openDatabase(
        path,
        version: 1,
        onOpen: (db){},
        onCreate: (Database someDB, int someVersion)async{

          print('Database created!!!!!!!!!!!');

          await someDB.execute(
              "CREATE TABLE IF NOT EXISTS notes("
                  "id INTEGER UNIQUE PRIMARY KEY,"
                  "title TEXT,"
                  "content TEXT,"
                  "color TEXT"
                  ")"
          );

          await someDB.execute(
              "CREATE TABLE IF NOT EXISTS tasks("
                  "id INTEGER UNIQUE PRIMARY KEY,"
                  "description TEXT,"
                  "completed TEXT,"
                  "dueDate TEXT"
                  ")"
          );

          await someDB.execute(
              "CREATE TABLE IF NOT EXISTS appointments("
                  "id INTEGER PRIMARY KEY,"
                  "title TEXT,"
                  "description TEXT,"
                  "apptDate TEXT,"
                  "apptTime TEXT"
                  ")"
          );

          await someDB.execute(
              "CREATE TABLE IF NOT EXISTS contacts("
                  "id INTEGER PRIMARY KEY,"
                  "name TEXT,"
                  "email TEXT,"
                  "phone TEXT,"
                  "birthday TEXT"
                  ")"
          );

        }
    );

    return db;
  }

  DBWorker._(){
    notes = NotesTable(_db);
    tasks = TasksTable(_db);
    appointments = AppointmentsTable(_db);
    contacts = ContactsTable(_db);
  }

  static final db = DBWorker._();

}