import 'package:flutter/cupertino.dart';
import 'package:flutter_book/tasks/tasksmodel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'notes/notesmodel.dart';
import 'utils.dart' as utils;


enum DbTable {NOTES, TASKS, APPOINTMENTS, CONTACTS}

class DBWorker{

  DBWorker._();

  static final db = DBWorker._();
  Database _db;
  DbTable _table;


  String get _tableName{
    var tableName = '';

    switch(_table){
      case DbTable.NOTES: tableName = 'notes'; break;
      case DbTable.TASKS: tableName = 'tasks'; break;
      case DbTable.APPOINTMENTS: tableName = 'appointments'; break;
      case DbTable.CONTACTS: tableName = 'contacts'; break;
    }

    return tableName;
  }


  Future<Database> get _database async{

    if(_db == null){
      _db = await _init();
    }

    return _db;
  }

  Future<Database> _init() async{

    var path = join(utils.docsDir.path, 'database1.db');
    Database db = await openDatabase(
        path,
        version: 2,
        onOpen: (db){},
    );

    await db.execute(
        "CREATE TABLE IF NOT EXISTS notes("
            "id INTEGER UNIQUE PRIMARY KEY,"
            "title TEXT,"
            "content TEXT,"
            "color TEXT"
            ")");

    await db.execute(
        "CREATE TABLE IF NOT EXISTS tasks("
            "id INTEGER UNIQUE PRIMARY KEY,"
            "description TEXT,"
            "completed TEXT,"
            "dueDate TEXT"
            ")");

    return db;
  }

  Future<void> create({@required DbTable table, @required dynamic record})async{

    Database db = await _database;
    _table = table;

    var val = await db.rawQuery(
        "SELECT MAX(id) + 1 AS id FROM " + _tableName
    );

    print(_tableName);

    int id = val.first['id'] == null ? 1 : val.first['id'];

    switch(_table){
      case DbTable.NOTES: await db.rawInsert(
          "INSERT INTO notes (id, title, content, color)"
              "VALUES (?,?,?,?)",
          [id, record.title, record.content, record.color]
          );break;

      case DbTable.TASKS: await db.rawInsert(
          "INSERT INTO tasks (id, description, completed, dueDate)"
              "VALUES (?,?,?,?)",
          [id, record.description, record.completed, record.dueDate]
      );break;
    }


  }

  Future<dynamic> get({@required DbTable table, @required int idx})async{

    Database db = await _database;
    _table = table;

    var resSet = await db.query(
        _tableName,
        where: 'id=?',
        whereArgs: [idx]
    );

    return _map2Record(resSet.first);
  }

  Future<List> getAll({@required DbTable table}) async {

    Database db = await _database;
    _table = table;

    var resSet = await db.query(
        _tableName
    );

    if(table == DbTable.TASKS){
      print(resSet);
    }

    return resSet.isNotEmpty?
    resSet.map((inputElem)=>_map2Record(inputElem)).toList():[];
  }

  Future<void> update({@required DbTable table, @required dynamic record}) async {

    Database db = await _database;
    _table = table;

    return await db.update(
        _tableName,
        _record2Map(record),
        where: 'id=?',
        whereArgs: [record.id]
    );
  }

  Future<void> delete({@required DbTable table, @required int idx}) async {

    Database db = await _database;
    _table = table;

    return await db.delete(
        _tableName,
        where: 'id=?',
        whereArgs: [idx]
    );
  }

  dynamic _map2Record(Map inMap){

    var record;

    switch(_table){
      case DbTable.NOTES: record = Note();
                    record.id = inMap['id'];
                    record.title = inMap['title'];
                    record.color = inMap['color'];
                    record.content = inMap['content'];
                    break;

      case DbTable.TASKS: record = Task();
                    record.id = inMap['id'];
                    record.description = inMap['description'];
                    record.dueDate = inMap['dueDate'];
                    record.completed = inMap['completed'];
                    break;

    }

    return record;
  }

  Map<String, dynamic> _record2Map(dynamic record){

    Map<String, dynamic> map = Map<String, dynamic>();

    switch(_table){
      case DbTable.NOTES: map['id'] = record.id;
                          map['title'] = record.title;
                          map['color'] = record.color;
                          map['content'] = record.content;
                          break;

      case DbTable.TASKS: map['id'] = record.id;
                          map['description'] = record.description;
                          map['dueDate'] = record.dueDate;
                          map['completed'] = record.completed;
                          break;
    }

    return map;
  }

}