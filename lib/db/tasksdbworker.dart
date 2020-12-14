import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../utils.dart' as utils;
import '../tasks/tasksmodel.dart';

class TasksDBWorker{

  Database _db;


  TasksDBWorker();

  Future<Database> get _database async{

    if(_db == null){
      _db = await _init();
    }

    return _db;
  }

  Future<Database> _init() async{

    var path = join(utils.docsDir.path, 'my1.db');
    Database db = await openDatabase(
        path,
        version: 1,
        onOpen: (db){},
        onCreate: (Database someDB, int someVersion)async{
          await someDB.execute(
              "CREATE TABLE IF NOT EXISTS tasks("
                  "id INTEGER UNIQUE PRIMARY KEY,"
                  "description TEXT,"
                  "completed TEXT,"
                  "dueDate TEXT"
                  ")"
          );
        }
    );

    return db;
  }

  Task _map2Task(Map someMap){

    Task task = Task();
    task.id = someMap['id'];
    task.description = someMap['description'];
    task.dueDate = someMap['dueDate'];
    task.completed = someMap['completed'];

    return task;
  }

  Map<String, dynamic> _task2Map(Task someTask){

    Map<String, dynamic> map = Map<String, dynamic>();

    map['id'] = someTask.id;
    map['description'] = someTask.description;
    map['dueDate'] = someTask.dueDate;
    map['completed'] = someTask.completed;


    return map;
  }

  Future<void> create(Task someTask)async{

    Database db = await _database;
    var val = await db.rawQuery(
        "SELECT MAX(id) + 1 AS id FROM tasks"
    );

    int id = val.first['id'] == null ? 1 : val.first['id'];

    return await db.rawInsert(
        "INSERT INTO tasks (id, description, completed, dueDate)"
            "VALUES (?,?,?,?)",
        [id, someTask.description, someTask.completed, someTask.dueDate]
    );
  }

  Future<Task> get(int someId)async{

    Database db = await _database;
    var resSet = await db.query(
        'tasks',
        where: 'id=?',
        whereArgs: [someId]
    );

    return _map2Task(resSet.first);
  }

  Future<List> getAll() async {

    Database db = await _database;
    var resSet = await db.query(
        'tasks'
    );

    return resSet.isNotEmpty?
    resSet.map((inputElem)=>_map2Task(inputElem)).toList():[];
  }

  Future<void> update(Task someTask) async {

    Database db = await _database;
    return await db.update(
        'tasks',
        _task2Map(someTask),
        where: 'id=?',
        whereArgs: [someTask.id]
    );
  }

  Future<void> delete(int someId) async {

    Database db = await _database;
    return await db.delete(
        'tasks',
        where: 'id=?',
        whereArgs: [someId]
    );
  }

}